extends CharacterBody2D
class_name Enemy

# Reference to the separate WanderBehavior script
@export var wander_behavior: WanderBehavior
var player_id: String = ""
#var sprites = [$Fish, $BrownCow, $WhiteCow]
var current_sprite

func _ready() -> void:
	set_up_sprite()

func _physics_process(_delta: float) -> void:
	if wander_behavior == null:
		push_error("wander_behavior is not assigned on Enemy!")
		return

	# Ask the wander behavior for this frame’s movement direction
	var dir = wander_behavior.update(global_position)
	if dir.x < 0:
		current_sprite.play("left")
	if dir.x > 0:
		current_sprite.play("right")

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
		
func on_enemy_killed(_enemy: Node2D):
	print("player id: ", player_id)
	if player_id == "dog":	
		print("dog died")
		Inventory.dog_meat += 1
		print("dog inventory updated: ", Inventory.dog_meat)
	if player_id == "cat":	
		Inventory.cat_meat += 1
		print("cat inventory updated: ", Inventory.cat_meat)
	
func set_up_sprite():
	print(player_id)
	var sprites = [$Fish, $BrownCow, $WhiteCow]
	for sprite in sprites:
		sprite.visible = false
	
	if player_id == "dog":
		var random_cow = randi_range(0,1)
		print(random_cow)
		if random_cow == 0:
			sprites[1].visible = true
			current_sprite = sprites[1]
		else:
			sprites[2].visible = true
			current_sprite = sprites[2]
	if player_id == "cat":
		sprites[0].visible = true
		current_sprite = sprites[0]

func _animal():
	pass
