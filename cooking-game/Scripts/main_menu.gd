extends Control

@onready var play: TextureButton = $Play
#@onready var credits: TextureButton = $Credits

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play.pressed.connect(_play_pressed)
	#credits.pressed.connect(_credits_pressed)
	#AudioPlayer.play_music_ui()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _play_pressed():
	#AudioPlayer._play_button()
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _credits_pressed():
	#AudioPlayer._play_button()
	get_tree().change_scene_to_file("res://Scenes/UI elements/credits_screen.tscn")

func _on_button_mouse_entered() -> void:
	#AudioPlayer._play_hover()
	pass




func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/tutorial.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/credits.tscn")
