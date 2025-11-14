class_name Main extends Node2D

@onready var minigame: Node2D = $Minigame1
@onready var cat = %SushiCat
@onready var dog = %BurgerDog



func _process(_delta: float) -> void:
	if GameStats.cat_state != GameStats.PlayerStates.KITCHEN:
		cat.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		cat.process_mode = Node.PROCESS_MODE_ALWAYS
	if GameStats.dog_state != GameStats.PlayerStates.KITCHEN:
		dog.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		dog.process_mode = Node.PROCESS_MODE_ALWAYS
