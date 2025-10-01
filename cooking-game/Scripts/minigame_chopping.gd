extends Node2D

# Check if chop input is from cat side (left) or dog side (right)
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dog_chop"):
		print("dog chop")
	elif event.is_action_pressed("cat_chop"):
		print("cat chop")
