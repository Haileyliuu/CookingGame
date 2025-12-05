extends Sprite2D

@export var chop_distance := 40.0
@export var chop_duration := 0.1   # seconds to move down
@export var return_duration := 0.15 # seconds to move back up

var start_position: Vector2
var current_tween: Tween = null

func _ready():
	# Center the knife on the screen
	var viewport_size = get_viewport_rect().size
	position = viewport_size * 0.5
	start_position = position

	# Ensure the sprite's pivot is centered
	centered = true

func chop():
	# Stop any existing tween to prevent stacking
	if current_tween:
		current_tween.kill()
		current_tween = null

	# Reset position to start (center) before starting new chop
	position = start_position

	var down_position = start_position + Vector2(0, chop_distance)

	current_tween = get_tree().create_tween()
	current_tween.tween_property(self, "position", down_position, chop_duration)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	current_tween.tween_property(self, "position", start_position, return_duration)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	current_tween.connect("finished", Callable(self, "_on_tween_finished"))

func _on_tween_finished():
	# Ensure knife ends exactly at the center
	current_tween = null
	position = start_position
