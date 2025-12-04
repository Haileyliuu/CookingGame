extends Control

#var customers = [preload("res://Art/PlaceholderArt/SushiCat.png"),
				#preload("res://Art/PlaceholderArt/BurgerDog.png"),
				#preload("res://Art/PlaceholderArt/american-cockroach.webp"),
				#preload("res://Art/PlaceholderArt/icon.svg")]
				

@onready var preloader = $ResourcePreloader
var customers = [preload("res://Art/Customers/Normal/Bear_Normal.PNG"),
				preload("res://Art/Customers/Normal/GCat_Normal.PNG"),
				preload("res://Art/Customers/Normal/PinkBunny_Normal.PNG"),
				preload("res://Art/Customers/Normal/Rottweiler_Normal.png"),
				preload("res://Art/Customers/Normal/Shiba_Normal.PNG"),
				preload("res://Art/Customers/Normal/WBunny_Normal.png")]
var angry_customers = [preload("res://Art/Customers/Angry/Bear_Angry.PNG"),
				preload("res://Art/Customers/Angry/GCat_Angry.PNG"),
				preload("res://Art/Customers/Angry/PinkBunny_Angry.PNG"),
				preload("res://Art/Customers/Angry/Rottweiler_Angry.png"),
				preload("res://Art/Customers/Angry/Shiba_Angry.PNG"),
				preload("res://Art/Customers/Angry/WBunny_Disgust.png")]

# index of customer png in customers
var cat_current_sprite
var dog_current_sprite

# sprite node currently spawned [big_sprite, small_sprite]
var cat_current_customer = []
var dog_current_customer = []

@onready var markers: Array[Marker2D] = []

func _load_customer_sprites():
	pass

func _ready() -> void:
	_load_customer_sprites()
	for m in $Markers.get_children():
		markers.append(m as Marker2D)
	
	new_customer("dog", false)
	new_customer("cat", false)

#creates a new customer, replaces sprite with angry sprite if cockroach delivered
func new_customer(player_id : String, angry: bool):
	var player_current_customer = get(player_id + "_current_customer")
	
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
	
	big_sprite.texture = customers[get(player_id + "_current_sprite")]
	little_sprite.texture = big_sprite.texture
	little_sprite.scale = Vector2(0.25, 0.25)
	
	var add_marker_index = 0
	if player_id == "dog":
		add_marker_index = 6
		
	big_sprite.position = markers[3 + add_marker_index].global_position
	little_sprite.position = markers[0 + add_marker_index].global_position
	
	add_child(big_sprite)
	move_to_marker(big_sprite, markers[4 + add_marker_index])
	add_child(little_sprite)
	move_to_marker(little_sprite, markers[1 + add_marker_index])

func leave_old_customer(player_id : String, angry: bool):
	var player_current_customer = get(player_id + "_current_customer")
	
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
