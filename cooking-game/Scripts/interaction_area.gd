class_name InteractionArea extends Area2D

#indicates object can be interacted with
@export var interact_name: String = "none"
@export var is_interactable: bool = true
#@export var interact_type = "none"
#@export var interact_value = "interact"

@onready var parent: Node = owner

@export var minigame: MiniGame
@export var object: Sprite2D
signal object_signal(o)

var select_shader = preload("res://Shaders/select.gdshader")

var interact: Callable = func(player_id: String):
	if player_id == minigame.player_id:
		interact_with_button()

func interact_with_button():
	if parent.is_in_group("Minigame"):
		minigame.end_minigame()
	else:
		minigame.start_minigame()
		emit_signal("object_signal", object)


func _on_area_entered(area: Area2D) -> void:
	if object != null && minigame != null && minigame.player != null:
		# check if player matches
		if minigame.player == area.get_parent().get_parent():
			object.material = ShaderMaterial.new()
			object.material.shader = select_shader


func _on_area_exited(_area: Area2D) -> void:
	if object != null:
		object.material = null
