class_name MiniGame extends Node2D

#this means that you have to drag the player into the inspector
#@export var player: Player

@export_enum("cat", "dog") var player_id: String
var player_mode: GameStats.PlayerStates
@onready var timer: Timer
@export var minigame_type: GameStats.PlayerStates

@onready var active = false
@onready var container := get_parent().get_parent().get_parent()

func _ready() -> void:
	add_to_group("Minigame")
	process_mode = Node.PROCESS_MODE_DISABLED
	#player_id = player.player_id

func _on_timeout_test():
	print("I timed out!")


func _process(_delta: float) -> void:
	if active:
		match player_id:
			"cat":
				player_mode = GameStats.cat_state
			"dog":
				player_mode = GameStats.dog_state
		if Input.is_action_just_pressed(player_id + "_select"):
			timer.start(1)
			print("Timer")
		if Input.is_action_just_released(player_id + "_select"):
			timer.stop()
			print("STOOOP")

func end_minigame() -> void:
	print("timed out")
	container.visible = false
	active = false
	timer.timeout.disconnect(end_minigame)
	process_mode = Node.PROCESS_MODE_DISABLED
	match player_id:
		"cat":
			GameStats.cat_state = GameStats.PlayerStates.KITCHEN
		"dog":
			GameStats.dog_state = GameStats.PlayerStates.KITCHEN

func start_minigame():
	
	timer = Timer.new()
	timer.one_shot = false # Set to true for a single timeout, false for repeating
	timer.autostart = false
	add_child(timer)
	timer.timeout.connect(end_minigame)
	
	container.visible = true
	active = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	match player_id:
		"cat":
			GameStats.cat_state = minigame_type
		"dog":
			GameStats.dog_state = minigame_type
