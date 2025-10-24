class_name Arrow
extends Node2D 

@onready var tween = get_tree().create_tween()
@export var speed: float = 1000  # launch speed
@onready var marker_2d: Marker2D = $"../Marker2D"



var launched := false
var velocity := Vector2.ZERO

func _ready():
	swing()

func swing():
	# change rotation_degrees property from its current value to 240 over 1 second
	tween.tween_property(self, "rotation_degrees", 240, 1)
	# change rotation_degrees property from its current value to 120 over 1 second
	tween.tween_property(self, "rotation_degrees", 120, 1)
	tween.set_loops()

func _process(delta):
	if launched:
		position += velocity * delta
		
		
func launch():
	if launched:
		return
	tween.kill()
	launched = true
	var dir = Vector2.UP.rotated(rotation)  # change to RIGHT if arrow points right
	velocity = dir.normalized() * speed
	

# hurtbox = the thing that does the damage
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.owner == null:
		print("owner is null")
		return
	if area.get_parent().has_method("_animal"):
		#print("animal collision")
		reset() #resets arrow
		#queue_free()


# reset back to spawn point and swing again
func reset():
	launched = false
	velocity = Vector2.ZERO
	global_position = marker_2d.global_position
	print("marker 2d: ", global_position)
	rotation = marker_2d.global_rotation

	# Restart swing
	tween = create_tween()
	swing()

func _arrow():
	pass


#use notifier instead of enabler bc enabler pauses the parent node
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("screen exited")
	reset()
