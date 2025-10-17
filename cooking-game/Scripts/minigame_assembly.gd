extends Node2D

var player_id = "dog"
signal player(p)

var sprites_added = []

@onready var recipe_label : Label = $Recipe
var recipe = [1, 2, 3, 4, 2, 1]
var current_recipe = []


@onready var dishes_label : Label = $DishesCreated
var dishes_created = 0

var up_texture = preload("res://Art/BurgerDog.png")
var down_texture = preload("res://Art/SushiCat.png")
var left_texture = preload("res://Art/icon.svg")
var right_texture = preload("res://Art/arrow.webp")

var offset = 0

func _ready() -> void:
	dishes_label.text = "Dishes created: " + str(dishes_created)
	recipe_label.text = "Recipe: " + str(recipe)
	player.emit(player_id)

func _process(_delta: float) -> void:
	pass
	
func _input(event):
	if event.is_action_pressed(player_id + "_up"):
		spawn_sprite(up_texture)
		current_recipe.push_back(1)
	elif event.is_action_pressed(player_id + "_down"):
		if Inventory.get(player_id + "_meat") > 0:
			spawn_sprite(down_texture)
			current_recipe.push_back(2)
			Inventory.set(str(player_id) + "_meat",  Inventory.get(str(player_id) + "_meat") - 1)
	elif event.is_action_pressed(player_id + "_left"):
		spawn_sprite(left_texture)
		current_recipe.push_back(3)
	elif event.is_action_pressed(player_id + "_right"):
		spawn_sprite(right_texture)
		current_recipe.push_back(4)
	elif  event.is_action_pressed(player_id + "_select"):
		if check_recipe():
			randomize_recipe()
		delete_sprites()
		
func spawn_sprite(texture: Texture2D):
	# Create a new sprite node
	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.scale = Vector2(0.3, 0.3)

	# set position of sprite (offset increase each sprite added to stack them)
	sprite.position = Vector2(600, 400 - offset)
	offset += 20
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
	recipe_label.text = "Recipe: " + str(recipe)
