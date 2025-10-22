extends CharacterBody2D
class_name Enemy

# Reference to the separate WanderBehavior script
@export var wander_behavior: WanderBehavior

func _physics_process(_delta: float) -> void:
	if wander_behavior == null:
		push_error("wander_behavior is not assigned on Enemy!")
		return

	# Ask the wander behavior for this frame’s movement direction
	var dir = wander_behavior.update(global_position)

	# Move in that direction
	velocity = dir * wander_behavior.move_speed
	move_and_slide()

	# Clamp the enemy’s position so it can’t go outside the marker bounds
	if wander_behavior.markers.size() > 0:
		global_position.x = clamp(global_position.x, wander_behavior.min_bounds.x, wander_behavior.max_bounds.x)
		global_position.y = clamp(global_position.y, wander_behavior.min_bounds.y, wander_behavior.max_bounds.y)
		
		
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("_arrow"):
		on_enemy_killed(area)
		print("dog meat updated: ", Inventory.dog_meat)

		queue_free()
	else:
		print("not an arrow")
		
func on_enemy_killed(enemy: Node2D):
	Inventory.dog_meat += 1
	
		
func _animal():
	pass
#extends CharacterBody2D
#class_name enemy
#
##@export var speed: float = 700
##var direction := Vector2.ZERO
##
##const screen = Vector2(800,500)
##var location = Vector2()
#@export var wander_direction : Node2D
#
#func _physics_process(delta: float) -> void:
	#velocity = wander_direction.direction * 200
	#move_and_slide()
#

#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
##func set_random_motion():
	##direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
##
##func _process(delta: float):
	##position += direction * speed * delta
	##_offscreen()
##
	### bounce on screen edges
	##
##
##func _offscreen():
	###var screen = get_viewport_rect().size
	###print(screen)
	##if position.x > screen.x - 50 or position.x < 0:
		##print(position.x)
		##position = position.clamp(Vector2.ZERO, screen)
	##if position.y > screen.y -50 or position.y < 0:
		##print(position.x)
		##position = position.clamp(Vector2.ZERO, screen)
##
