class_name Dish extends Node2D

const cat_food = preload("res://Art/SushiArt/FinishedSushiPlate.png")
const dog_food = preload("res://Art/BurgerArt/FinishedBurger.png")

const dish_scene: PackedScene = preload("res://Scenes/Objects/Dish.tscn")

var spot_pos: int

var cockroach:= false

static func place(pos: int, player_id: String) -> Dish:
	var new_dish = dish_scene.instantiate()
	var new_sprite = Sprite2D.new()
	
	var food = cat_food if (player_id == "cat") else dog_food
	new_sprite.texture = food
	new_sprite.scale = Vector2(.2, .2)
	new_dish.add_child(new_sprite)
	new_dish.spot_pos = pos
	return new_dish
