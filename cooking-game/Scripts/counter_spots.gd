extends Node2D

@export_enum("cat", "dog") var player_id: String

var cat_board_sprite = preload("res://Art/Game Backgroud Layers/Objects/CatBoard.png")
var dog_board_sprite = preload("res://Art/Game Backgroud Layers/Objects/DogBoard.png")
var cat_food = preload("res://Art/SushiArt/FinishedSushiPlate.png")
var dog_food = preload("res://Art/BurgerArt/FinishedBurger.png")
var player_food
var spot_taken = [false, false, false, false, false, false]
var current_spot = 0
var assembly_minigame
signal counter_full(c)

func _ready() -> void:
	print(spot_taken)
	player_food = get(player_id + "_food")
	for i in range(6):
		var spot = get_node("Spot" + str(i+1))
		var player_board_sprite = get(player_id + "_board_sprite")
		
		spot.texture = player_board_sprite
		
		var food = spot.get_child(0)
		if player_id == "cat":
			food.scale = Vector2(.2, .2)
			food.position.y = -10
		if player_id == "dog":
			food.scale = Vector2(.18, .18)
			food.position.y = -20
		
		# set up all the interaction areas for each spot
		var interaction_area = spot.get_child(1)
		interaction_area.who_can_interact = player_id
		interaction_area.interact = Callable(self, "_on_interact").bind(interaction_area)


func _on_minigame_assembly_dish_created() -> void:
	var i = 0
	var placed = false
	var numTrue = 0
	while !placed && i < spot_taken.size():
		if spot_taken[i] == false && i+1 != current_spot:
			spot_taken[i] = true
			placed = true
		else:
			if spot_taken[i] == true:
				numTrue+=1
			i+=1
	if numTrue == 5:
		spot_taken[current_spot-1] = true
		emit_signal("counter_full", true)
	display_spots()
	print(spot_taken)

func display_spots():
	for i in range(6):
		var spot = get_node("Spot" + str(i+1))
		
		if spot_taken[i]:
			spot.get_child(0).texture = player_food

func _on_interact(area):
	# print(assembly_minigame)
	current_spot = area.object.name.substr(4).to_int()
	assembly_minigame.start_minigame()
	

func _on_interaction_area_minigame_signal(m: Variant) -> void:
	assembly_minigame = m
