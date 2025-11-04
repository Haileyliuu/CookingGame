class_name MiniGame extends Node

#this means that you have to drag the player into the inspector
@export var player: Player

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
