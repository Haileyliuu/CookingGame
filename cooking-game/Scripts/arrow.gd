class_name Arrow
extends Node2D  # or RigidBody2D if you want physics

@onready var tween = get_tree().create_tween()
@export var speed: float = 1000  # launch speed
#@export var target: Node2D  # assign your target object in the Inspector
@onready var icon: Sprite2D = $Icon
@onready var marker_2d: Marker2D = $"../Marker2D"



var launched := false
var velocity := Vector2.ZERO

func _ready():
	swing()

func swing():
	tween.tween_property(self, "rotation_degrees", 120, 1)
	tween.tween_property(self, "rotation_degrees", 240, 1)
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
	
#hurtbox = the thing that does the damage

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.owner == null:
		print("owner is null")
		return
	if area.get_parent().has_method("_animal"):
		print("animal collision")
		queue_free()
		
# flew off-screen
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	reset()

# reset back to spawn point and swing again
func reset():
	launched = false
	velocity = Vector2.ZERO
	global_position = marker_2d.global_position
	rotation = marker_2d.global_rotation

	# Restart swing
	tween = create_tween()
	swing()


	
func _arrow():
	pass
