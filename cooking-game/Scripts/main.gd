extends Node2D

@onready var minigame_scene: PackedScene = preload("res://Scenes/Minigames/minigame1.tscn")
@onready var popup_container: Control = $"CanvasLayer/PopupContainer" # Adjust path as needed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed(): # Or whatever triggers the minigame
	var minigame_instance = minigame_scene.instantiate()
	popup_container.add_child(minigame_instance)
	popup_container.show() # Make the container visible
	# Optionally, disable input for the main game
	get_tree().paused = true # Or implement a custom input blocking mechanism
