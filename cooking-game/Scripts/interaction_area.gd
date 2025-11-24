class_name InteractionArea extends Area2D

#indicates object can be interacted with
@export var interact_name: String = "none"
@export var is_interactable: bool = true
#@export var interact_type = "none"
#@export var interact_value = "interact"

@onready var parent: Node = owner
