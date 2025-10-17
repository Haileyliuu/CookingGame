extends Node2D
class_name MinigameHunting

@onready var arrow: Node2D = $arrow
@onready var icon_scene: PackedScene = preload("res://Scenes/Minigames/hunting_minigame/enemy.tscn")  # your fish/cow icon scene
@onready var marker: Marker2D = $Marker2D

@export var point1: Vector2 = Vector2(10, 250)
@export var point2: Vector2 = Vector2(1000, 600)
@export var spawn_interval: float = 3.0
@export var max_enemies: int = 3

var rng := RandomNumberGenerator.new()
var spawn_timer := 0.0
var active_enemies: Array = []


func _ready() -> void:
	randomize()


func _process(delta: float) -> void:
	# handle spawning cooldown
	spawn_timer -= delta
	if spawn_timer <= 0.0:
		spawn_timer = spawn_interval
		spawn_enemy()

	# clean up dead enemies
	active_enemies = active_enemies.filter(func(e): return is_instance_valid(e))


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		arrow.launch()


func _get_random_point_inside(p1: Vector2, p2: Vector2) -> Vector2:
	var x_value: float = randf_range(p1.x, p2.x)
	var y_value: float = randf_range(p1.y, p2.y)
	return Vector2(x_value, y_value)


func spawn_enemy():
	# maintain enemy cap
	if active_enemies.size() >= max_enemies:
		return

	var enemy = icon_scene.instantiate()
	add_child(enemy)

	# place randomly within defined region
	enemy.position = _get_random_point_inside(point1, point2)
	enemy.set_random_motion()
	active_enemies.append(enemy)

		

##@export var arrow_scene: PackedScene = preload("res://Scenes/arrow.tscn")
#@onready var marker_2d: Marker2D = $Marker2D
#
#var can_shoot = true
#
#func _process(delta):
	#if Input.is_action_just_pressed("shoot") and can_shoot:
		#shoot_arrow()
#
#func shoot_arrow():
	#can_shoot = false
	#arrow.launch()
	##var arrow = load(arrow)
	#get_tree().current_scene.add_child(arrow)  # or add_child if you want local parenting
	#arrow.global_position = marker_2d.global_position
	#arrow.rotation = marker_2d.global_rotation
	#
#
	## simple reload timer
	#await get_tree().create_timer(0.5).timeout
	#can_shoot = true
