extends Node2D
class_name minigame_hunting

@onready var arrow: Node2D = $arrow
#@onready var animal_scene: PackedScene = preload("res://Scenes/Minigames/hunting_minigame/enemy.tscn")  # your fish/cow icon scene
#@onready var marker: Marker2D = $Marker2D

# where the sprite spawns
#@export var point1: Vector2 = Vector2(10, 50)
#@export var point2: Vector2 = Vector2(50, 70)
#@export var spawn_interval: float = 1
#
#@export var max_enemies: int = 3
#
#var rng := RandomNumberGenerator.new()
#var spawn_timer := 0.0
#var active_enemies: Array = []


func _ready() -> void:
	pass
	#spawn_enemy()
	#randomize()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		arrow.launch()

#func _process(delta: float) -> void:
	## handle spawning cooldown
	#spawn_timer -= delta #subtracts 
	#if spawn_timer <= 0.0:
		#spawn_timer = spawn_interval
		#spawn_enemy()

	# clean up dead enemies
	#active_enemies = active_enemies.filter(func(e): return is_instance_valid(e))





#func _get_random_point_inside(p1: Vector2, p2: Vector2) -> Vector2:
	#var x_value: float = randf_range(p1.x, p2.x)
	#print(x_value)
	#var y_value: float = randf_range(p1.y, p2.y)
	#return Vector2(x_value, y_value)
#
#
#func spawn_enemy():
	## maintain enemy cap
	#if active_enemies.size() >= max_enemies:
		#return
#
	#var enemy = animal_scene.instantiate()
	#add_child(enemy)
	#enemy.position = _get_random_point_inside(point1, point2)
	#var screen = get_viewport_rect().size
	#if enemy.position.x > screen.x - 50 or enemy.position.x < 0:
		##print(position.x)
		#enemy.position = position.clamp(Vector2.ZERO, screen)
	#if enemy.position.y > screen.y -50 or enemy.position.y < 0:
		##print(position.x)
		#enemy.position = position.clamp(Vector2.ZERO, screen)
	##if enemy.has_method("_offscreen"):
		##var screen = get_viewport_rect().size
		##if position.x > screen.x - 50 or position.x < 0:
			##print(position.x)
			##position = position.clamp(Vector2.ZERO, screen)
		##if position.y > screen.y -50 or position.y < 0:
			##print(position.x)
			##position = position.clamp(Vector2.ZERO, screen)
		#
#
	## place randomly within defined region
	#enemy.position = _get_random_point_inside(point1, point2)
	#enemy.set_random_motion()
	#active_enemies.append(enemy)
