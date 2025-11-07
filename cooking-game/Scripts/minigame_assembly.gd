extends Node2D

var player_id = "dog"
signal player(p)

@onready var screen_size = get_viewport_rect().size
var sprites_added = []

var recipe = [0, 0, 0, 0, 0, 0]
signal recipe_signal(r)
var current_recipe = []


@onready var dishes_label : Label = $DishesCreated
var dishes_created = 0

@onready var background_art = [
	$Background,
	$Board,
	$Recipe,
	$AssemblyButtons
]


var cat_food_art = {
	1 : [preload("res://Art/SushiArt/ImitationCrab.png"), 50],
	2 : [preload("res://Art/SushiArt/Fish.png"), 40],
	3 : [preload("res://Art/SushiArt/Cucumber.png"), 50],
	4 : [preload("res://Art/SushiArt/Avocado.png"), 50],
	5 : preload("res://Art/SushiCat.png")
}

var dog_food_art = {
	1 : [preload("res://Art/BurgerArt/Cheese.PNG"), 40],
	2 : [preload("res://Art/BurgerArt/Patty.PNG"), 82],
	3 : [preload("res://Art/BurgerArt/Lettuce.PNG"), 60],
	4 : [preload("res://Art/BurgerArt/Tomato.PNG"), 60],
	5 : preload("res://Art/BurgerArt/BottomBun.PNG"),
	6 : preload("res://Art/BurgerArt/TopBun.PNG")
}

var player_food_art = get(player_id + "_food_art")

var offset = 0

func _ready() -> void:
	dishes_label.text = "Dishes created: " + str(dishes_created)
	player.emit(player_id)
	randomize_recipe()
	display_background()

func _process(_delta: float) -> void:
	pass
	
func _input(event):
	if event.is_action_pressed(player_id + "_select"):
			if check_recipe():
				randomize_recipe()
			delete_sprites()
	if current_recipe.size() < 8:
		if event.is_action_pressed(player_id + "_up"):
			spawn_sprite(1)
			current_recipe.push_back(1)
		elif event.is_action_pressed(player_id + "_down"):
			if Inventory.get(player_id + "_meat") > 0:
				spawn_sprite(2)
				current_recipe.push_back(2)
				Inventory.set(str(player_id) + "_meat",  Inventory.get(str(player_id) + "_meat") - 1)
		elif event.is_action_pressed(player_id + "_left"):
			spawn_sprite(3)
			current_recipe.push_back(3)
		elif event.is_action_pressed(player_id + "_right"):
			spawn_sprite(4)
			current_recipe.push_back(4)
	else:
		for dir in ["up", "down", "left", "right"]:
			if event.is_action_pressed(player_id + "_" + dir):
				create_warning()
			
func spawn_sprite(texture_num):
	var texture = player_food_art[texture_num][0]
	
	# Create a new sprite node
	var sprite = Sprite2D.new()
	sprite.texture = texture
	
	# Dynamic scaling based on viewport height (relative to 1080p baseline)
	var scale_factor = screen_size.y / 1080.0 * (0.8 if player_id == "cat" else 0.55)
	sprite.scale = Vector2.ONE * scale_factor

	# set position of sprite (offset increase each sprite added to stack them)
	var start_y = screen_size.y * (0.6 if player_id == "cat" else 0.5)   # % down the screen
	var start_x = screen_size.x * 0.5   # % x across
	sprite.position = Vector2(start_x, start_y - offset)
	offset += (player_food_art[texture_num][1] * scale_factor)
	

	# Add it to the scene so it appears
	sprites_added.push_back(sprite)
	add_child(sprite)
	
	
func delete_sprites():
	while not sprites_added.is_empty():
		sprites_added.pop_back().queue_free()
	offset = 0
	current_recipe = []
	
func check_recipe():
	if current_recipe == recipe:
		dishes_created+=1
		dishes_label.text = "Dishes created: " + str(dishes_created)
		return true
	return false

# Recipe has 1 or 2 meat (random location) and the rest is random ingredients
func randomize_recipe():
	var new_recipe = []
	
	# Decide how many 2's to insert: either 1 or 2
	var num_twos = randi_range(1, 2)
	
	# Insert the required number of 2's
	for i in num_twos:
		new_recipe.append(2)

	# Fill the rest of the recipe with random values (excluding 2)
	while new_recipe.size() < recipe.size():
		var rand_val = randi_range(1, 4)
		if rand_val == 2:
			continue # Skip 2 to prevent exceeding the allowed number
		new_recipe.append(rand_val)

	# Shuffle the recipe so 2's are not always in front
	new_recipe.shuffle()
	
	# Assign to the actual recipe
	recipe = new_recipe
	
	emit_signal("recipe_signal", recipe)
	
func display_finished():
	#var sprite = Sprite2D.new()
	#sprite.texture = player_food_art[5]
	#add_child(sprite)
	pass

func display_background():
	for art in background_art:
		art.visible = true
	
	# position board
	var scale_factor = screen_size.y / 1080.0 * 0.6
	var start_x = screen_size.x * 0.5   # % x across
	var start_y = screen_size.y * 0.5   # % y down
	background_art[1].position = Vector2(start_x, start_y)
	background_art[1].scale = Vector2.ONE * scale_factor
	
	# position recipe
	scale_factor = screen_size.y / 1080.0 * 1.3
	start_y = screen_size.y * 0.15
	background_art[2].position = Vector2(start_x, start_y)
	background_art[2].scale = Vector2.ONE * scale_factor
	
	# position buttons
	scale_factor = screen_size.y / 1080.0 * 0.75
	start_y = screen_size.y * 0.85
	background_art[3].position = Vector2(start_x, start_y)
	background_art[3].scale = Vector2.ONE * scale_factor
	
	# scale background
	scale_factor = screen_size.y / 1080.0
	background_art[0].scale = Vector2.ONE * scale_factor

func create_warning():
	var warning_label = Label.new()
	warning_label.text = "Reached max ingredients! Clear your station!"
	
	var my_font = load("res://Art/Fonts/MADE Tommy Soft Bold PERSONAL USE.otf")
	warning_label.add_theme_font_override("font", my_font)
	warning_label.add_theme_font_size_override("font_size", 45)
	warning_label.add_theme_color_override("font_color", Color(0.954, 0.954, 0.954, 1.0))
	
	#warning_label.add_theme_constant_override("shadow_offset_x", 3)
	#warning_label.add_theme_constant_override("shadow_offset_y", 3)
	#warning_label.add_theme_color_override("font_shadow_color", Color(0.278, 0.137, 0.0, 0.502))
	warning_label.add_theme_constant_override("outline_size", 20)
	warning_label.add_theme_color_override("font_outline_color", Color(0.545, 0.166, 0.088, 1.0))
	add_child(warning_label)
	
	await get_tree().process_frame
	var label_size = warning_label.size
	var pos = Vector2(
		screen_size.x / 2 - label_size.x / 2,
		1.9 * screen_size.y / 3 - label_size.y / 2
	)
	warning_label.position = pos
	
	var tween = get_tree().create_tween()
	tween.tween_property(warning_label, "modulate:a", 0, 1)
	
	await get_tree().create_timer(1).timeout
	warning_label.queue_free()
	
	
