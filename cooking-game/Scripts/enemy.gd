extends Node2D
class_name icon

@export var speed: float = 700
var direction := Vector2.ZERO

func _ready():
	set_random_motion()

func set_random_motion():
	direction = Vector2(randf_range(-5, 5), randf_range(-5, 5)).normalized()

func _process(delta: float):
	position += direction * speed * delta

	# bounce on screen edges
	var screen = get_viewport_rect().size
	print(screen.x)
	if position.x < 0 or position.x > screen.x:
		direction.x *= -.5
	if position.y < 0 or position.y > screen.y:
		direction.y *= -0.5

func _on_Hitbox_body_entered(body):
	if body.name == "arrow":  # when arrow hits
		queue_free()
