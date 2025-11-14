extends CharacterBody2D
class_name Enemy

# Reference to the separate WanderBehavior script
@export var wander_behavior: WanderBehavior
var player_id: String = ""

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
		
		queue_free()
	else:
		print("not an arrow")
		
func on_enemy_killed(enemy: Node2D):
	print("player id: ", player_id)
	if player_id == "dog":	
		print("dog died")
		Inventory.dog_meat += 1
		print("dog inventory updated: ", Inventory.dog_meat)
	if player_id == "cat":	
		Inventory.cat_meat += 1
		print("cat inventory updated: ", Inventory.cat_meat)
	
	
		
func _animal():
	pass
