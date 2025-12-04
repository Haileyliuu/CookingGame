extends MiniGame
class_name minigame_hunting

#var player_id := ""

@onready var arrow: Node2D = $arrow
@onready var EnemyScene = preload("res://Scenes/Minigames/hunting_minigame/enemy.tscn")
@onready var screen_size = get_viewport_rect().size

@export var min_enemies: int = 1
@export var max_enemies: int = 3
@export var spawn_min: Vector2 = Vector2(200, 200)
@export var spawn_max: Vector2 = Vector2(800, 600)

# Cooldown before a killed enemy respawns (in seconds)
@export var respawn_cooldown: float = 5

var enemies: Array = []
signal total_spawned(t)
var target_total: int = 3

signal player(p)
signal arrow_positioned

@onready var background_art = [
	$Background,
	$Character,
	$arrow
]

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	player.emit(player_id)
	spawn_initial_enemies()
	display_background()


func spawn_initial_enemies():
	#var num_to_spawn = randi_range(min_enemies, max_enemies)
	for i in range(3):
		_add_enemy()
	#print("Spawned initial ", num_to_spawn, " enemies.")


func _add_enemy():
	if enemies.size() >= target_total:
		return
	
	var enemy_instance = EnemyScene.instantiate()
	var x = randf_range(spawn_min.x, spawn_max.x)
	var y = randf_range(spawn_min.y, spawn_max.y)
	enemy_instance.global_position = Vector2(x, y)
	enemy_instance.scale = Vector2(0.5, 0.5)
	
	enemy_instance.player_id = player_id
	
	$Enemies.add_child(enemy_instance)
	enemies.append(enemy_instance)
	emit_signal("total_spawned", enemies.size())

	# Connect its death signal
	enemy_instance.tree_exited.connect(func(): _on_enemy_killed(enemy_instance))
	print("Spawned enemy ", total_spawned, " of ", target_total)


func _on_enemy_killed(enemy_instance):
	enemies.erase(enemy_instance)
	enemy_instance.queue_free()
	emit_signal("total_spawned", enemies.size())
	#print("Enemy killed. Starting individual cooldown...")

	## Create a timer for this specific respawn
	#var respawn_timer = Timer.new()
	#respawn_timer.wait_time = respawn_cooldown
	#respawn_timer.one_shot = true
	#respawn_timer.timeout.connect(func(): _add_enemy())
	#add_child(respawn_timer)
	#respawn_timer.start()
#
#func _respawn_enemy(p_id: String):
	#if total_spawned >= target_total:
		#print("Already at total limit; not respawning.")
		#return
#
	#var new_enemy = EnemyScene.instantiate()
	#var x = randf_range(spawn_min.x, spawn_max.x)
	#var y = randf_range(spawn_min.y, spawn_max.y)
	#new_enemy.global_position = Vector2(x, y)
#
	## Assign the correct player_id right away
	#new_enemy.player_id = p_id
#
	#add_child(new_enemy)
	#enemies.append(new_enemy)
	#total_spawned += 1
#
	#new_enemy.tree_exited.connect(func(): _on_enemy_killed(new_enemy))
	#print("Respawned an enemy after cooldown for player:", p_id)

	
func display_background():
	# position character
	var scale_factor = screen_size.y / 1080.0 * 0.6
	var start_x = screen_size.x * 0.5   # % x across
	var start_y = screen_size.y * 0.18   # % y down
	
	background_art[1].position = Vector2(start_x, start_y)
	background_art[1].scale = Vector2.ONE * scale_factor
	
	# position arrow
	start_y = screen_size.y * 0.18
	$Marker2D.position = Vector2(start_x, start_y)
	emit_signal("arrow_positioned")
	
	## position buttons
	#scale_factor = screen_size.y / 1080.0 
	#start_y = screen_size.y * 0.82
	#background_art[3].position = Vector2(start_x, start_y)
	#background_art[3].scale = Vector2.ONE * scale_factor
	
	# scale background
	scale_factor = screen_size.x / 961
	background_art[0].scale = Vector2.ONE * scale_factor



func _input(event: InputEvent) -> void:
	if event.is_action_pressed(player_id + "_shoot"):
		arrow.launch()


func _on_timer_timeout() -> void:
	_add_enemy()
