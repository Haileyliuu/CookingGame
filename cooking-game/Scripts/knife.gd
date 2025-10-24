extends Sprite2D
@export var chop_distance := 40.0
@export var chop_duration := 0.1  # seconds to move down
@export var return_duration := 0.15  # seconds to move back up

var start_position: Vector2

func _ready():
	start_position = position


func chop():
	# Create a Tween and animate the knife down, then back up
	var tween = get_tree().create_tween()
	var down_position = start_position + Vector2(0, chop_distance)
	
	# Move down
	tween.tween_property(self, "position", down_position, chop_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# Then move back up
	tween.tween_property(self, "position", start_position, return_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
