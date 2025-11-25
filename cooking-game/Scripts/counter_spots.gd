extends Node2D

@export_enum("cat", "dog") var player_id: String

var cat_board_sprite = preload("res://Art/Game Backgroud Layers/Objects/CatBoard.png")
var dog_board_sprite = preload("res://Art/Game Backgroud Layers/Objects/DogBoard.png")
var spot_taken = [false, false, false, false, false, false]
var current_spot = "none"

func _ready() -> void:
	for i in range(6):
		var spot = get_node("Spot" + str(i+1))
		var player_board_sprite = get(player_id + "_board_sprite")
		
		spot.texture = player_board_sprite


func _on_minigame_assembly_dish_created() -> void:
	pass # Replace with function body.
