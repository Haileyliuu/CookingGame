extends Control

var player_id := ""
var recipe = []
@onready var label = $Label

# load all the slot sprites
@onready var slot1 = $Slot1
@onready var slot2 = $Slot2
@onready var slot3 = $Slot3
@onready var slot4 = $Slot4
@onready var slot5 = $Slot5
@onready var slot6 = $Slot6


# load all food art 
var fish_art = preload("res://Art/SushiCat.png")
var avocado_art = preload("res://Art/BurgerDog.png")
var crab_art = preload("res://Art/arrow.webp")
var cucumber_art = preload("res://Art/icon.svg")

var patty_art = preload("res://Art/SushiCat.png")
var cheese_art = preload("res://Art/BurgerDog.png")
var tomato_art = preload("res://Art/icon.svg")
var lettuce_art = preload("res://Art/arrow.webp")


var cat_food_art = {
	1 : preload("res://Art/BurgerDog.png"),
	2 : preload("res://Art/SushiCat.png"),
	3 : preload("res://Art/icon.svg"),
	4 : preload("res://Art/arrow.webp")
}

var dog_food_art = {
	1 : cheese_art,
	2 : patty_art,
	3 : tomato_art,
	4 : lettuce_art
}


func _process(_delta: float) -> void:
	label.text = str(recipe)
	show_recipe()
	
	
func show_recipe():
	# loop through recipe [123456]
	# set slot i = recipe[i].art
	for i in range(recipe.size()):
		var slot = get_node("Slot" + str(i+1))
		var player_food_art = get(player_id + "_food_art")
		
		slot.texture = player_food_art[recipe[i]]
		slot.scale = Vector2(0.2, 0.2)
	
	
	

func _on_minigame_assembly_recipe_signal(r: Variant) -> void:
	recipe = r


func _on_minigame_assembly_player(p: Variant) -> void:
	player_id = p
