extends Control

var player_id := ""
var recipe = []

var cat_food_art = {
	1 : preload("res://Art/AssemblyUI/CatButtons/CrabButton.png"),
	2 : preload("res://Art/SushiArt/Fish.png"),
	3 : preload("res://Art/AssemblyUI/CatButtons/CucumberButton.png"),
	4 : preload("res://Art/AssemblyUI/CatButtons/AvocadoButton.png")
}

var dog_food_art = {
	1: preload("res://Art/AssemblyUI/DogButtons/CheeseButton.png"),
	2: preload("res://Art/AssemblyUI/DogButtons/PattyButton.png"),
	3: preload("res://Art/AssemblyUI/DogButtons/LettuceButton.png"),
	4: preload("res://Art/AssemblyUI/DogButtons/TomatoButton.png")
}


func _process(_delta: float) -> void:
	show_recipe()
	
	
func show_recipe():
	# loop through recipe [123456]
	# set slot i = recipe[i].art
	for i in range(recipe.size()):
		var slot = get_node("Slot" + str(i+1))
		var player_food_art = get(player_id + "_food_art")
		
		slot.texture = player_food_art[recipe[i]]
		slot.scale = Vector2(0.12, 0.12)
	

func _on_minigame_assembly_recipe_signal(r: Variant) -> void:
	recipe = r


func _on_minigame_assembly_player_signal(p: Variant) -> void:
	player_id = p
