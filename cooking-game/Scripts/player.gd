class_name Player extends CharacterBody2D

@export var player_id : String # either "cat" or "dog"

const PUSHABILITY = 1.8 # bigger = more pushable

@export var speed = 400

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	get_input()
	
	for i in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		var other_player = collision.get_collider()
		if other_player.is_in_group("Player"):
			velocity += collision.get_normal() * collision.get_collider_velocity().length() * PUSHABILITY
			
	
	move_and_slide()


func get_input():
	var input_direction = Input.get_vector(player_id + "_left", player_id + "_right", player_id + "_up", player_id + "_down")
	velocity = input_direction * speed
