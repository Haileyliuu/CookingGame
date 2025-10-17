extends Node2D
class_name icon

@export var speed: float = 700
var direction := Vector2.ZERO

func _ready():
	pass
	#set_random_motion()

func set_random_motion():
	direction = Vector2(randf_range(-5, 5), randf_range(-5, 5)).normalized()

func _process(delta: float):
	position += direction * speed * delta

	# bounce on screen edges
	var screen = get_viewport_rect().size
	if position.x < 0 or position.x > screen.x:
		direction.x *= -.5
	if position.y < 0 or position.y > screen.y:
		direction.y *= -0.5

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "arrow":  # when arrow hits
		queue_free()
		print("delete animal")

func _animal():
	pass


#func _on_hitbox_area_entered(area: Area2D) -> void:
	#pass # Replace with function body.
