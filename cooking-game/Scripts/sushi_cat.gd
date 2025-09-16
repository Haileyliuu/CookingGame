extends CharacterBody2D

@export var speed = 400

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_input()
	move_and_slide()


func get_input():
	var input_direction = Input.get_vector("cat_left", "cat_right", "cat_up", "cat_down")
	velocity = input_direction * speed
