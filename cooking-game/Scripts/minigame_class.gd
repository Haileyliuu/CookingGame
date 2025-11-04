class_name MiniGame extends Node

#this means that you have to drag the player into the inspector
@export var player: Player

enum Players {CAT, DOG}
@export var player_type: Players
var player_mode: GameStats.PlayerStates

@export var minigame_type: GameStats.PlayerStates

@onready var active = false

func _ready() -> void:
	add_to_group("Minigame")
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	if active:
		match player_type:
			Players.CAT:
				player_mode = GameStats.cat_state
			Players.CAT:
				player_mode = GameStats.dog_state
		

func end_minigame() -> void:
	self.visible = false
	active = false
	process_mode = Node.PROCESS_MODE_DISABLED
	match player_type:
		Players.CAT:
			GameStats.cat_state = GameStats.PlayerStates.KITCHEN
		Players.DOG:
			GameStats.dog_state = GameStats.PlayerStates.KITCHEN

func start_minigame():
	self.visible = true
	active = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	match player_type:
		Players.CAT:
			GameStats.cat_state = minigame_type
		Players.DOG:
			GameStats.dog_state = minigame_type
