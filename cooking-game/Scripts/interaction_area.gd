class_name InteractionArea extends Area2D

#indicates object can be interacted with
@export var interact_name: String = "none"
@export var is_interactable: bool = true
#@export var interact_type = "none"
#@export var interact_value = "interact"

@onready var parent: Node = owner

@onready var object = get_parent() # the object the interaction area is connected to
@export_enum("cat", "dog", "both") var who_can_interact: String

var select_shader = preload("res://Shaders/select.gdshader")


# to use the interact function, override the function in the ready function of the object that contains
# the interaction area using (write interact code in a new function "_on_interact"):
# interaction_area.interact = Callable(self, "_on_interact")
# Check counterSpots for example
var interact: Callable = func():
	pass


func _on_area_entered(area: Area2D) -> void:
	if object != null:
		# check if player matches (if interacting_component.parent player_id matches)
		if area.get_parent().get_parent().player_id == who_can_interact || who_can_interact == "both":
			object.material = ShaderMaterial.new()
			object.material.shader = select_shader


func _on_area_exited(_area: Area2D) -> void:
	if object != null:
		object.material = null
