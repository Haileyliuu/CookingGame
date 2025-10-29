extends Node2D

var player_id = "dog"
signal player(p)

var sprites_added = []

var recipe = [0, 0, 0, 0, 0, 0]
signal recipe_signal(r)
var current_recipe = []


@onready var dishes_label : Label = $DishesCreated
var dishes_created = 0

var cat_food_art = {
	1 : preload("res://Art/BurgerDog.png"),
	2 : preload("res://Art/SushiCat.png"),
	3 : preload("res://Art/icon.svg"),
	4 : preload("res://Art/arrow.webp"),
	5 : preload("res://Art/SushiCat.png")
}

var dog_food_art = {
	1 : [preload("res://Art/BurgerArt/Cheese.PNG"), 15],
	2 : [preload("res://Art/BurgerArt/Patty.PNG"), 28],
	3 : [preload("res://Art/BurgerArt/Lettuce.PNG"), 20],
	4 : [preload("res://Art/BurgerArt/Tomato.PNG"), 20],
	5 : preload("res://Art/BurgerArt/BottomBun.PNG"),
	6 : preload("res://Art/BurgerArt/TopBun.PNG")
}

var player_food_art = get(player_id + "_food_art")

var offset = 0

func _ready() -> void:
	dishes_label.text = "Dishes created: " + str(dishes_created)
	player.emit(player_id)
	randomize_recipe()

func _process(_delta: float) -> void:
	pass
	
func _input(event):
	if event.is_action_pressed(player_id + "_select"):
			if check_recipe():
				randomize_recipe()
			delete_sprites()
	if current_recipe.size() < 10:
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
	sprite.scale = Vector2(0.3, 0.3)

	# set position of sprite (offset increase each sprite added to stack them)
	sprite.position = Vector2(600, 400 - offset)
	offset += player_food_art[texture_num][1]
	sprites_added.push_back(sprite)

	# Add it to the scene so it appears
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

func create_warning():
	var warning_label = Label.new()
	warning_label.text = "Reached max ingredients! Clear your station!"
	warning_label.position = Vector2(100, 200)
	add_child(warning_label)
	
	var tween = get_tree().create_tween()
	tween.tween_property(warning_label, "modulate:a", 0, 1)
	
	await get_tree().create_timer(1).timeout
	warning_label.queue_free()
	
	
