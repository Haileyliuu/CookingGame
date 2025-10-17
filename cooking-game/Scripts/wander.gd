extends Node2D
class_name WanderBehavior

# === CONFIGURATION ===
@export var group_name: String = "cow"               # Group containing your Marker2Ds
@export var move_speed: float = 100.0                # Movement speed for the enemy
@export var arrive_distance: float = 10.0            # Distance threshold to "arrive" at a marker
@export var wait_min: float = 0.05       # Minimum wait time after reaching a marker
@export var wait_max: float = 0.12                 # Maximum wait time after reaching a marker

# === INTERNAL STATE ===
var markers: Array = []              # List of all Marker2Ds in the scene
var current_target: Marker2D = null  # Current destination marker
var previous_target: Marker2D = null # Previous marker (used to avoid repeats)
var waiting: bool = false            # Whether we are currently waiting before moving again
var rng := RandomNumberGenerator.new()

# Bounding box for keeping the enemy inside the area
var min_bounds: Vector2
var max_bounds: Vector2

# === SETUP ===
func _ready():
	rng.randomize()

	# Collect all Marker2Ds in the specified group
	for n in get_tree().get_nodes_in_group(group_name):
		if n is Marker2D:
			markers.append(n)

	if markers.is_empty():
		push_warning("No Marker2Ds found in group '%s'!" % group_name)
		return

	# Compute min/max bounds based on all marker positions
	min_bounds = markers[0].global_position
	max_bounds = markers[0].global_position

	for m in markers:
		min_bounds.x = min(min_bounds.x, m.global_position.x)
		min_bounds.y = min(min_bounds.y, m.global_position.y)
		max_bounds.x = max(max_bounds.x, m.global_position.x)
		max_bounds.y = max(max_bounds.y, m.global_position.y)

	print_debug("[Wander] Bounds:", min_bounds, "to", max_bounds)

	# Pick the initial target
	_pick_new_target(Vector2.ZERO)

# === MAIN LOGIC ===
# Called every frame by the enemy. Returns the direction the enemy should move this frame.
func update(from_position: Vector2) -> Vector2:
	if markers.is_empty():
		return Vector2.ZERO

	# If waiting, stand still
	if waiting:
		return Vector2.ZERO

	# If no current target or we've reached the target, start waiting
	if current_target == null or from_position.distance_to(current_target.global_position) <= arrive_distance:
		_start_wait(from_position)
		return Vector2.ZERO

	# Otherwise, move toward the target
	return (current_target.global_position - from_position).normalized()

# === WAITING STATE ===
# Called when the enemy reaches a target. Pauses, then selects a new target.
func _start_wait(from_position: Vector2) -> void:
	if waiting:
		return

	waiting = true
	previous_target = current_target
	var wait_time = rng.randf_range(wait_min, wait_max)
	

	print_debug("[Wander] Reached ", previous_target.name if previous_target else "None",
				" → waiting for ", wait_time, "s")
	

	#can remove this if you don't want it to stop at marker2d's
	#moves faster = harder
	#wait_time is useless wo this line (idk to keep or remove)
	#await get_tree().create_timer(wait_time).timeout

	_pick_new_target(from_position)
	waiting = false

# === TARGET SELECTION ===
# Picks a new random marker as the wander target.
func _pick_new_target(from_position: Vector2) -> void:
	if markers.is_empty():
		current_target = null
		return

	var choice: Marker2D = null
	var max_attempts := 20
	var attempts := 0

	while attempts < max_attempts:
		choice = markers[rng.randi_range(0, markers.size() - 1)]
		var not_same := (previous_target == null or choice != previous_target)
		var far_enough := from_position.distance_to(choice.global_position) > arrive_distance
		if not_same and far_enough:
			break
		attempts += 1

	current_target = choice
	print_debug("[Wander] New target → ", current_target.name)

# === OPTIONAL DEBUG DRAW ===
# Draws a red line from the wander controller to the current target (for visualization)
func _draw():
	if current_target:
		draw_line(Vector2.ZERO, current_target.global_position - global_position, Color.RED, 2)

func _process(_delta):
	queue_redraw()
