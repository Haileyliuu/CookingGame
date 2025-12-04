class_name Main extends Node2D

@onready var cat = %SushiCat
@onready var dog = %BurgerDog

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if GameStats.cat_state == GameStats.PlayerStates.KITCHEN or GameStats.cat_state == GameStats.PlayerStates.SABOTAGE:
		cat.process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		cat.process_mode = Node.PROCESS_MODE_DISABLED
	if GameStats.dog_state == GameStats.PlayerStates.KITCHEN or GameStats.dog_state == GameStats.PlayerStates.SABOTAGE:
		dog.process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		dog.process_mode = Node.PROCESS_MODE_DISABLED
