extends Node2D

@export_enum("cat", "dog") var player_id: String

var cat_board_sprite = preload("res://Art/Game Backgroud Layers/Objects/CatBoard.png")
var dog_board_sprite = preload("res://Art/Game Backgroud Layers/Objects/DogBoard.png")
var cat_food = preload("res://Art/SushiArt/FinishedSushiPlate.png")
var dog_food = preload("res://Art/BurgerArt/FinishedBurger.png")
var player_food
var spot_taken: Array[Dish] = [null, null, null, null, null, null]
var current_spot = 0
@export var assembly_minigame: MiniGame
signal counter_full(c)
signal pickup(cockroach)

func _ready() -> void:
	print(spot_taken)
	player_food = get(player_id + "_food")
	for i in range(6):
		var spot = get_node("Spot" + str(i+1))
		
		
		# set up all the interaction areas for each spot
		var interaction_area = spot.get_child(0)
		interaction_area.who_can_interact = "both"
		interaction_area.interact = Callable(self, "_on_interact").bind(interaction_area)


func _on_minigame_assembly_dish_created() -> void:
	var i = 0
	var numTrue = 0
	place_food(current_spot)
	#while !placed && i < spot_taken.size():
		#if spot_taken[i] == false && i+1 != current_spot:
			#spot_taken[i] = true
			#place_food(i)
			#placed = true
		#else:
			#if spot_taken[i] == true:
				#numTrue+=1
			#i+=1
	while i < spot_taken.size():
		if spot_taken[i]:
			numTrue += 1
		i += 1
	if numTrue == 5:
		emit_signal("counter_full", true)
	#display_spots()
	print(spot_taken)

func place_food(i: int) -> void:
	var spot = get_node("Spot" + str(i + 1))
	var food = Dish.place(i, player_id)
	spot_taken[i] = food
	spot.add_child(food)

func take_food(i: int) -> void:
	var spot = get_node("Spot" + str(i + 1))
	var food: Dish = spot.get_child(1)
	pickup.emit(food.cockroach)
	food.queue_free()
	
	
#func display_spots():
	#for i in range(6):
		#var spot = get_node("Spot" + str(i+1))
		#
		#if spot_taken[i]:
			#spot.get_child(0).texture = player_food

func _on_interact(incoming_id, area):
	# print(assembly_minigame)
	var player_interacting: Player = get_tree().get_first_node_in_group(incoming_id)
	current_spot = area.object.name.substr(4).to_int() - 1
	if (GameStats.get(incoming_id + "_state") == GameStats.PlayerStates.SABOTAGE 
		and player_interacting.player_cockroach != null):
		return
	#if the player going here has a cockroach, put a cockroach in the food
	if player_interacting.player_cockroach != null and spot_taken[current_spot] != null:
		spot_taken[current_spot].cockroach = true
		player_interacting.player_cockroach.queue_free()
		GameStats.set(incoming_id + "_state", GameStats.PlayerStates.KITCHEN)
		
	if incoming_id == player_id and player_interacting.meal == null:
		if spot_taken[current_spot] == null:
			assembly_minigame.start_minigame()
		else:
			take_food(current_spot)
	

func _on_interaction_area_minigame_signal(m: Variant) -> void:
	assembly_minigame = m
