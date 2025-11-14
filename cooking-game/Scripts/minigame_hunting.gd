extends MiniGame
class_name minigame_hunting

var player_id := "dog"

@onready var arrow: Node2D = $arrow
@onready var EnemyScene = preload("res://Scenes/Minigames/hunting_minigame/enemy.tscn")

@export var min_enemies: int = 1
@export var max_enemies: int = 3
@export var spawn_min: Vector2 = Vector2(200, 200)
@export var spawn_max: Vector2 = Vector2(800, 600)

# Cooldown before a killed enemy respawns (in seconds)
@export var respawn_cooldown: float = 5

var enemies: Array = []
var total_spawned: int = 0
var target_total: int = 3

signal player(p)

func _ready():
	player.emit(player_id)
	spawn_initial_enemies()


func spawn_initial_enemies():
	var num_to_spawn = randi_range(min_enemies, max_enemies)
	for i in range(num_to_spawn):
		_add_enemy()
	print("Spawned initial ", num_to_spawn, " enemies.")


func _add_enemy():
	if total_spawned >= target_total:
		return
	
	var enemy_instance = EnemyScene.instantiate()
	var x = randf_range(spawn_min.x, spawn_max.x)
	var y = randf_range(spawn_min.y, spawn_max.y)
	enemy_instance.global_position = Vector2(x, y)
	
	enemy_instance.player_id = player_id
	
	add_child(enemy_instance)
	enemies.append(enemy_instance)
	total_spawned += 1

	# Connect its death signal
	enemy_instance.tree_exited.connect(func(): _on_enemy_killed(enemy_instance))
	print("Spawned enemy ", total_spawned, " of ", target_total)


func _on_enemy_killed(enemy_instance):
	enemies.erase(enemy_instance)
	print("Enemy killed. Starting individual cooldown...")

	# Create a timer for this specific respawn
	var respawn_timer = Timer.new()
	respawn_timer.wait_time = respawn_cooldown
	respawn_timer.one_shot = true
	var current_player_id = player_id
	respawn_timer.timeout.connect(func(): _respawn_enemy(current_player_id))
	add_child(respawn_timer)
	respawn_timer.start()

func _respawn_enemy(p_id: String):
	if total_spawned >= target_total:
		print("Already at total limit; not respawning.")
		return

	var new_enemy = EnemyScene.instantiate()
	var x = randf_range(spawn_min.x, spawn_max.x)
	var y = randf_range(spawn_min.y, spawn_max.y)
	new_enemy.global_position = Vector2(x, y)

	# Assign the correct player_id right away
	new_enemy.player_id = p_id

	add_child(new_enemy)
	enemies.append(new_enemy)
	total_spawned += 1

	new_enemy.tree_exited.connect(func(): _on_enemy_killed(new_enemy))
	print("Respawned an enemy after cooldown for player:", p_id)

	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(player_id + "_shoot"):
		arrow.launch()
