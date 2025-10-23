## Minigame to chop ingredients.
##
## Keep track of the player ID (dog/cat). Press the 
## assigned key until a set number of chops is achieved.
## Then the food is chopped and the minigame finishes.
##

## Cat = 'S' key
## Dog = down arrow key
## Number of chops = 5

extends Node2D

signal chop_done(player)

const CHOPS_REQUIRED := 5

var active_player : String = ""
var chops_left : int = 0
var chopping_active : bool = false

@onready var chop_label = $ChopLabel
@onready var prompt_label = $PromptLabel
@onready var chop_sound = $ChopSound

func start_chopping(player: String):
	active_player = player
	chops_left = CHOPS_REQUIRED
	chopping_active = true
	prompt_label.text = "%s: Chop the food!" % player.capitalize()
	update_label()


func _input(event: InputEvent) -> void:
	if not chopping_active:
		return

	if active_player == "dog" and event.is_action_pressed("dog_chop"):
		handle_chop()

	elif active_player == "cat" and event.is_action_pressed("cat_chop"):
		handle_chop()


func handle_chop():
	chop_sound.stop()
	chop_sound.pitch_scale = randf_range(0.9, 1.1)
	chop_sound.play()
	
	chops_left -= 1
	update_label()

	if chops_left <= 0:
		chopping_active = false
		prompt_label.text = "%s finished chopping!" % active_player.capitalize()
		emit_signal("chop_done", active_player)


func update_label():
	chop_label.text = "Chops left: %d" % chops_left


## Dog is hardcoded to begin when the tscn plays.
func _ready():

	start_chopping("cat")
	start_chopping("dog")
