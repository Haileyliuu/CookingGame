extends Control

var player_id = ""

@onready var cat_back = $CatBack
@onready var dog_back = $DogBack

var backgrounds = {}  # dictionary mapping player IDs to boards

func _ready() -> void:
	backgrounds = {
		"cat": cat_back,
		"dog": dog_back
	}

func _on_minigame_assembly_player(p: Variant) -> void:
	player_id = p
	var player_back = backgrounds.get(player_id)
	if player_back:
		player_back.visible = true
