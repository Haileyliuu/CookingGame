extends Node2D  # or RigidBody2D if you want physics

@onready var tween = get_tree().create_tween()
@export var speed: float = 1000  # launch speed
#@export var target: Node2D  # assign your target object in the Inspector
@onready var icon: Sprite2D = $Icon


var launched := false
var velocity := Vector2.ZERO

func _ready():
	swing()

func swing():
	tween.tween_property(self, "rotation_degrees", 120, 1.0)
	tween.tween_property(self, "rotation_degrees", 240, 1.0)
	tween.set_loops()

func _process(delta):
	if launched:
		position += velocity * delta
		
		
#
func launch():
	if launched:
		return
	tween.kill()
	launched = true
	var dir = Vector2.UP.rotated(rotation)  # change to RIGHT if arrow points right
	velocity = dir.normalized() * speed
	
