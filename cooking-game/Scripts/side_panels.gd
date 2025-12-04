class_name SidePanels extends Control

@onready var preloader = $ResourcePreloader
var customers = [preload("res://Art/Customers/Normal/Teddy_Normal.png"),
				preload("res://Art/Customers/Normal/GCat_Normal.png"),
				preload("res://Art/Customers/Normal/YBunny_Normal.png"),
				preload("res://Art/Customers/Normal/Rottweiler_Normal.png"),
				preload("res://Art/Customers/Normal/Shiba_Normal.png"),
				preload("res://Art/Customers/Normal/WBunny_Normal.png")]
var angry_customers = [preload("res://Art/Customers/Angry/Teddy_Angry.png"),
				preload("res://Art/Customers/Angry/GCat_Angry.png"),
				preload("res://Art/Customers/Angry/YBunny_Angry.png"),
				preload("res://Art/Customers/Angry/Rottweiler_Angry.png"),
				preload("res://Art/Customers/Angry/Shiba_Angry.png"),
				preload("res://Art/Customers/Angry/WBunny_Angry.png")]

# index of customer png in customers
var cat_current_sprite
var dog_current_sprite

# sprite node currently spawned [big_sprite, small_sprite]
var cat_current_customer = []
var dog_current_customer = []

# Customer Timer
var cat_timer: Timer
@onready var cat_progress: TextureProgressBar = $CatProgress
var dog_timer: Timer
@onready var dog_progress: TextureProgressBar = $DogProgress
const CUST_MAX_TIME := 4.0
var cust_time = CUST_MAX_TIME
var ct_ratio = cust_time
@onready var markers: Array[Marker2D] = []

# Score counters
@onready var cat_score = $CatScore
@onready var dog_score = $DogScore

func _process(delta: float) -> void:
	cat_progress.value = cat_timer.time_left/ct_ratio * 100
	dog_progress.value = dog_timer.time_left/ct_ratio * 100
	
	cat_score.text = str(GameStats.cat_score)
	dog_score.text = str(GameStats.dog_score)

func _ready() -> void:
	for m in $Markers.get_children():
		markers.append(m as Marker2D)
		
	# Timers
	cat_timer = Timer.new()
	cat_timer.one_shot = false
	cat_timer.autostart = false
	cat_timer.wait_time = CUST_MAX_TIME
	add_child(cat_timer)
	
	dog_timer = Timer.new()
	dog_timer.one_shot = false
	dog_timer.autostart = false
	dog_timer.wait_time = CUST_MAX_TIME
	add_child(dog_timer)
	
	var main: Main = get_tree().root.get_child(2)
	main.threshold_passed.connect(_threshold_passed)
	
	new_customer("dog", false)
	new_customer("cat", false)

func _threshold_passed(threshold):
	cust_time = cust_time / 2

func _score_points(player_id: String, angry: bool):
	var point = -1 if angry else 1
	var score = GameStats.get(player_id + "_score")
	score = score + point
	GameStats.set(player_id + "_score", score)

#creates a new customer, replaces sprite with angry sprite if cockroach delivered
func new_customer(player_id : String, angry: bool):
	var player_current_customer = get(player_id + "_current_customer")
	
	# Timer shit
	var timer = get(player_id + "_timer")
	var progress_bar = get(player_id + "_progress")
	if !timer.is_stopped():
		timer.stop()
	progress_bar.hide()
	
	# Check if there is currently a customer at register
	if !player_current_customer.is_empty():
		leave_old_customer(player_id, angry)
		await get_tree().create_timer(.5).timeout
	
	var big_sprite := Sprite2D.new()
	player_current_customer.push_back(big_sprite)
	var little_sprite := Sprite2D.new()
	player_current_customer.push_back(little_sprite)
	
	
	var random_customer = randi_range(0, customers.size()-1)
	while random_customer == cat_current_sprite || random_customer == dog_current_sprite:
		random_customer = randi_range(0, customers.size()-1)
	set(player_id + "_current_sprite", random_customer)
	
	var player_current_sprite = customers[get(player_id + "_current_sprite")]
	
	big_sprite.texture = player_current_sprite
	little_sprite.texture = big_sprite.texture
	
	var max_height = 800
	var tex_size = player_current_sprite.get_size()
	
	var scale_factor = max_height / tex_size.y
	big_sprite.scale = Vector2(scale_factor, scale_factor)
	little_sprite.scale = Vector2(scale_factor*.25, scale_factor*.25)
	
	
	var add_marker_index = 0
	if player_id == "dog":
		add_marker_index = 6
		
	big_sprite.position = markers[3 + add_marker_index].global_position
	little_sprite.position = markers[0 + add_marker_index].global_position
	
	add_child(big_sprite)
	move_to_marker(big_sprite, markers[4 + add_marker_index])
	add_child(little_sprite)
	move_to_marker(little_sprite, markers[1 + add_marker_index])
	
	#start timer after customer appears
	await get_tree().create_timer(1.0).timeout
	ct_ratio = cust_time #this keeps progress bars from updating on threshold change
	timer.start(cust_time)
	timer.timeout.connect(new_customer.bind(player_id, true))
	progress_bar.show()

func leave_old_customer(player_id : String, angry: bool):
	var player_current_customer = get(player_id + "_current_customer")
	
	# Score points when customer leaves
	_score_points(player_id, angry)
	
	var add_marker_index = 0
	if player_id == "dog":
		add_marker_index = 6
	
	if angry:
		var index = get(player_id + "_current_sprite")
		player_current_customer[0].texture = angry_customers[index]
		player_current_customer[1].texture = angry_customers[index]
	
	hop(player_current_customer[0])
	hop(player_current_customer[1])
	await get_tree().create_timer(0.5).timeout
	
	move_to_marker(player_current_customer[0], markers[5 + add_marker_index], 1.7)
	move_to_marker(player_current_customer[1], markers[2 + add_marker_index], 1.7)
	
	var big_sprite = player_current_customer.pop_front()
	var small_sprite = player_current_customer.pop_front()
	
	await get_tree().create_timer(2.0).timeout
	big_sprite.queue_free()
	small_sprite.queue_free()


func move_to_marker(sprite: Node2D, target_marker: Marker2D, time := 1.0):
	var tween = create_tween()
	tween.tween_property(sprite, "position", target_marker.global_position, time)


func hop(sprite: Node2D):
	var height := 50.0
	var time := 0.2
	var tween = create_tween()
	
	# go up
	tween.tween_property(sprite, "position:y", sprite.position.y - height*sprite.scale.y, time/2)
	
	# then go back down
	tween.tween_property(sprite, "position:y", sprite.position.y, time/2)


func _on_cat_register_delivered_dish(cockroach: bool) -> void:
	new_customer("cat", cockroach)

func _on_dog_register_delivered_dish(cockroach: bool) -> void:
	new_customer("dog", cockroach)
