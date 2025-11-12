class_name InteractionArea extends Area2D

#indicates object can be interacted with
@export var interact_name: String = "none"
@export var is_interactable: bool = true
#@export var interact_type = "none"
#@export var interact_value = "interact"

@onready var parent: Node = owner

@export var minigame: MiniGame


var interact: Callable = func(player_id: String):
	if player_id == minigame.player_id:
		interact_with_button()

func interact_with_button():
	if parent.is_in_group("Minigame"):
		minigame.end_minigame()
	else:
		minigame.start_minigame()
