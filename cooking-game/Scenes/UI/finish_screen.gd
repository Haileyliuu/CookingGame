extends Control

@onready var replay: TextureButton = $ColorRect/Replay
@onready var menu: TextureButton = $"ColorRect/Main Menu"
@onready var winner: Label = $WhoWins
#@onready var credits: TextureButton = $Credits

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	replay.pressed.connect(_play_pressed)
	menu.pressed.connect(_menu_pressed)
	if GameStats.cat_score < GameStats.dog_score:
		winner.text = "Dog Wins!!!"
	elif GameStats.dog_score < GameStats.cat_score:
		winner.text = "Cat Wins!!!"
	else:
		winner.text = "NOBODY WINS!!!!"
	#credits.pressed.connect(_credits_pressed)
	#AudioPlayer.play_music_ui()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
func _play_pressed():
	#AudioPlayer._play_button()
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
