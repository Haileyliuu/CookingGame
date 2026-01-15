class_name Cockroach extends Area2D

@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D
@onready var anim : AnimationPlayer = $AnimationPlayer

const bug_scene: PackedScene = preload("res://Scenes/Minigames/sabotoge/cockroach.tscn")

var is_caught := false
static var bugs_in_kitchen = 0

const SPAWN_LIMIT = 1
const SPEED = 200.0

static func spawn(start_pos): #-> Cockroach:
	if bugs_in_kitchen < SPAWN_LIMIT:
		var newBug = bug_scene.instantiate()
		newBug.position = start_pos
		bugs_in_kitchen += 1
		return newBug

static func catch(start_pos: Vector2) -> Cockroach:
	var newBug = bug_scene.instantiate()
	newBug.position = start_pos
	newBug.is_caught = true
	bugs_in_kitchen -= 1
	return newBug
	

func _ready() -> void:
	_move_npc()
	nav_agent.target_reached.connect(_move_npc)
	anim.play("Walk");

func _move_npc():
	var random_pos: Vector2
	random_pos.x = randi_range(300, 1600)
	random_pos.y = randi_range(200, 1000)
	nav_agent.set_target_position(random_pos)

func _physics_process(delta: float) -> void:
	if is_caught:
		return
	var destination = nav_agent.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	#var player_global_position = player.global_transform.origin
	#var look_at_dir = Vector3(global_position.x + player_global_position.z, 0, global_position.z + player_global_position.x)
	if nav_agent.is_navigation_finished() || !nav_agent.is_target_reachable():
		_move_npc()
	
	position += direction * SPEED * delta
	rotation = lerpf(rotation, atan2(local_destination.y, local_destination.x) + PI/2, delta * 10)
	
	
