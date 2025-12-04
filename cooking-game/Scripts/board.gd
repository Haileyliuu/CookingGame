extends Node2D

var player_id = ""

@onready var cat_board = $CatBoard
@onready var dog_board = $DogBoard

var boards = {}  # dictionary mapping player IDs to boards

func _ready() -> void:
	boards = {
		"cat": cat_board,
		"dog": dog_board
	}

func _on_minigame_assembly_player_signal(p: Variant) -> void:
	player_id = p
	var player_board = boards.get(player_id)
	if player_board:
		player_board.visible = true
