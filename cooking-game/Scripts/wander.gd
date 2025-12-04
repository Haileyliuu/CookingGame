extends Node2D
class_name WanderBehavior



# === CONFIGURATION ===
@export var group_name: String = "cow"         # Group containing your Marker2Ds
@export var move_speed: float = 1500         # Movement speed for the enemy
@export var arrive_distance: float = 10.0            # Distance threshold to "arrive" at a marker
@export var wait_min: float = 0.5       # Minimum wait time after reaching a marker
@export var wait_max: float = 1    

# === INTERNAL STATE ===
var markers: Array = []              # List of all Marker2Ds in the scene
var current_target: Marker2D = null  # Current destination marker
var previous_target: Marker2D = null # Previous marker (used to avoid repeats)
var waiting: bool = false            # Whether we are currently waiting before moving again
var rng := RandomNumberGenerator.new()

# === VARIABLES FOR SEPERATION ===
var seperation_distance = 20
var local_flockmates = []
var speed = 2
var max_speed = 3
var direction = Vector2(0, 1)
var seperation_weight = 5

# Bounding box for keeping the enemy inside the area
var min_bounds: Vector2
var max_bounds: Vector2
var last_position: Vector2
var stuck_frames := 0

var just_picked := false


# === SETUP ===
func _ready():
	last_position = global_position

	rng.randomize()

	# Collect all Marker2Ds in the specified group
	for n in get_tree().get_nodes_in_group(group_name):
		if n is Marker2D:
			markers.append(n)

	if markers.is_empty():
		print("no markers in array")
		return

	# Compute min/max bounds based on all marker positions
	min_bounds = markers[0].global_position
	max_bounds = markers[0].global_position

	for m in markers:
		min_bounds.x = min(min_bounds.x, m.global_position.x)
		min_bounds.y = min(min_bounds.y, m.global_position.y)
		max_bounds.x = max(max_bounds.x, m.global_position.x)
		max_bounds.y = max(max_bounds.y, m.global_position.y)

	# Pick the initial target
	_pick_new_target(Vector2.ZERO)
	

func _physics_process(delta: float) -> void:
	if markers.is_empty():
		return
	# Get base wandering direction
	var wander_dir = update(global_position)
	# Apply flock separation (adjusts to avoid nearby animals)
	var flock_dir = _flock_direction()
	# Combine both directions
	direction = (wander_dir + flock_dir).normalized()
	# Move the enemy using the combined direction
	global_position += direction * move_speed * delta
	
	
#func _physics_process(delta: float) -> void:
	#if markers.is_empty():
		#return
#
	## Standard wandering + flocking
	#var wander_dir = update(global_position)
	#var flock_dir = _flock_direction()
	#direction = (wander_dir + flock_dir).normalized()
#
	## --- Move the enemy ---
	#var before = global_position
	#global_position += direction * move_speed * delta
	#var after = global_position
#
	## --- Detect slowing down (stuck on wall / corner / bad direction) ---
	#var moved = after.distance_to(before)
#
	#if moved < 1.0:   # Movement too small → stuck
		#stuck_frames += 1
	#else:
		#stuck_frames = 0
#
	## After 10 frames of being stuck → pick new target
	#if stuck_frames > 10:
		#_pick_new_target(global_position)
		#stuck_frames = 0
#
	## Update last_position
	#last_position = after
#

	

	
# ===SEPERATION LOGIC ===
func _flock_direction():
	var seperation = Vector2()
	
	for flockmate in local_flockmates:
		#uses euclidian distance formula?
		var distance = self.position.distance_to(flockmate.position)
		if distance < seperation_distance:
			#subtract to point away from other enemy                            stronger push if they overlap
			
			seperation -= (flockmate.position - self.position).normalized() * (seperation_distance / distance * speed)
			
	return (direction + seperation * seperation_weight).limit_length(max_speed) 
			
#populate flockmates array if another animal enters the collision
func _on_detection_radius_body_entered(body: Node2D) -> void:
	if body == self:
		return
	if body.has_method("_animal"):
		print("adding to flockmate array")
		local_flockmates.push_back(body)
		
		#idk if this works
		#_pick_new_target(Vector2.ZERO)
		#var wait_time = rng.randf_range(wait_min, wait_max)
		#await get_tree().create_timer(wait_time).timeout


func _on_detection_radius_body_exited(body: Node2D) -> void:
	if body.has_method("_animal"):
		local_flockmates.erase(body)


# === MAIN LOGIC ===
# Called every frame by the enemy. Returns the direction the enemy should move this frame.
func update(from_position: Vector2) -> Vector2:
	if markers.is_empty():
		return Vector2.ZERO

	# If waiting, stand still
	if waiting:
		return Vector2.ZERO

	# If no current target or we've reached the target, start waiting
	#if current_target == null or from_position.distance_to(current_target.global_position) <= arrive_distance:
		#_start_wait(from_position)
		#return Vector2.ZERO
		
	if current_target == null or from_position.distance_to(current_target.global_position) <= arrive_distance:
		_pick_new_target(from_position)
		

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
	print("wait: ",wait_time)
	

	#can remove this if you don't want it to stop at marker2d's
	#moves faster = harder
	#wait_time is useless wo this line (idk to keep or remove)
	await get_tree().create_timer(wait_time).timeout

	_pick_new_target(from_position)
	waiting = false

# === TARGET SELECTION ===
# Picks a new random marker as the wander target.
func _pick_new_target(from_position: Vector2) -> void:
	print("pick new target")
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
func goto_target(from_position: Vector2) -> Vector2:
	return (current_target.global_position - from_position).normalized()
