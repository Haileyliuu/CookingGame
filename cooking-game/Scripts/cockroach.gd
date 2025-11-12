extends Area2D

@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	_move_npc()
	nav_agent.target_reached.connect(_move_npc)

func _move_npc():
	var random_pos: Vector2
	random_pos.x = randi_range(300, 1600)
	random_pos.y = randi_range(200, 1000)
	nav_agent.set_target_position(random_pos)

func _physics_process(delta: float) -> void:
	var destination = nav_agent.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	#var player_global_position = player.global_transform.origin
	#var look_at_dir = Vector3(global_position.x + player_global_position.z, 0, global_position.z + player_global_position.x)
	if nav_agent.is_navigation_finished() || !nav_agent.is_target_reachable():
		_move_npc()
	
	position += direction * 200.0 * delta
	
	
