extends Node2D
class_name minigame_hunting

var player_id := "cat"

@onready var arrow: Node2D = $arrow

# Preload your Enemy scene (the one with the wander_behavior inside)
@onready var EnemyScene = preload("res://Scenes/Minigames/hunting_minigame/enemy.tscn")

# Number of enemies to spawn
@export var min_enemies: int = 1
@export var max_enemies: int = 3
#if < 3 enemies spawned and enemie(s) are killed on screen,
#create cooldown timer (10 seconds) change scenes(put somewhere else)
#keep spawning enemies until add up to 3

# Random spawn area (adjust these values to fit your map)
@export var spawn_min: Vector2 = Vector2(200, 200)
@export var spawn_max: Vector2 = Vector2(800, 600)

# Store references to spawned enemies
var enemies: Array = []

signal player(p)

func _ready():
	player.emit(player_id)
	spawn_enemies()


func spawn_enemies():
	var num_to_spawn = randi_range(min_enemies, max_enemies)
	print("Spawning", num_to_spawn, "enemies")

	for i in range(num_to_spawn):
		_add_enemy()


func _add_enemy():
	var enemy_instance = EnemyScene.instantiate()
# Random spawn position inside your playable area
	var x = randf_range(spawn_min.x, spawn_max.x)
	var y = randf_range(spawn_min.y, spawn_max.y)
	enemy_instance.global_position = Vector2(x, y)
# Add the enemy to the minigame scene
	add_child(enemy_instance)
# Store it in the list for tracking
	enemies.append(enemy_instance)

	print("Spawned", enemies.size(), "enemies in minigame_hunting")
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(player_id+"_shoot"):		
		arrow.launch()
