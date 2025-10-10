extends Node2D
class_name MinigameHunting
@onready var arrow: Node2D = $arrow

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		print("shoot pressed!")
		arrow.launch()
		

##@export var arrow_scene: PackedScene = preload("res://Scenes/arrow.tscn")
#@onready var marker_2d: Marker2D = $Marker2D
#
#var can_shoot = true
#
#func _process(delta):
	#if Input.is_action_just_pressed("shoot") and can_shoot:
		#shoot_arrow()
#
#func shoot_arrow():
	#can_shoot = false
	#arrow.launch()
	##var arrow = load(arrow)
	#get_tree().current_scene.add_child(arrow)  # or add_child if you want local parenting
	#arrow.global_position = marker_2d.global_position
	#arrow.rotation = marker_2d.global_rotation
	#
#
	## simple reload timer
	#await get_tree().create_timer(0.5).timeout
	#can_shoot = true
