class_name Player extends CharacterBody2D

@export var player_id : String = "" # either "cat" or "dog"

const PUSHABILITY = 1.8 # bigger = more pushable

@export var speed = 400

var input_direction: Vector2 = Vector2(0,0) # This is mainly for rotating the bug net
@onready var animation = $AnimatedSprite2D
@onready var bug_net = $Pivot/BugNet
var last_dir := Vector2.DOWN   # default facing down

var meal : Dish = null
var player_cockroach : Cockroach = null

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
	if get_tree().paused:
		velocity = Vector2.ZERO
		return
	
	input_direction = Input.get_vector(player_id + "_left", player_id + "_right", player_id + "_up", player_id + "_down")
	velocity = input_direction * speed
	$Pivot.rotation = last_dir.angle()
	# --- Animation handling ---
	if input_direction != Vector2.ZERO:
		last_dir = input_direction
		
		# Choose animation by direction
		if abs(input_direction.x) > abs(input_direction.y):
			if input_direction.x > 0:
				animation.play("walk_right")
			else:
				animation.play("walk_left")
		else:
			if input_direction.y > 0:
				animation.play("walk_down")
			else:
				animation.play("walk_up")
	
	# IDLE animations based on last_dir
	else:
		if abs(last_dir.x) > abs(last_dir.y):
			if last_dir.x > 0:
				animation.play("idle_right")
			else:
				animation.play("idle_left")
		else:
			if last_dir.y > 0:
				animation.play("idle_down")
			else:
				animation.play("idle_up")


func _on_cat_assembly_pickup(cockroach: bool) -> void:
	var dish = Dish.place(0, player_id)
	dish.cockroach = cockroach
	dish.scale = Vector2(.5,.5)
	dish.position.y -= 100
	dish.rotation = deg_to_rad(90)
	meal = dish
	add_child(dish)


func _on_dog_assembly_pickup(cockroach: bool) -> void:
	var dish = Dish.place(0, player_id)
	dish.cockroach = cockroach
	dish.scale = Vector2(.5,.5)
	dish.position.y -= 100
	meal = dish
	add_child(dish)
