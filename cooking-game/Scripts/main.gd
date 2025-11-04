class_name Main extends Node2D

@onready var minigame: Node2D = $Minigame1
@onready var cat = %SushiCat

func start_minigame():
	minigame.show()
	minigame.process_mode = Node.PROCESS_MODE_ALWAYS
	GameStats.cat_state = GameStats.HUNTING

func _process(delta: float) -> void:
	if GameStats.cat_state != GameStats.KITCHEN:
		cat.process_mode = Node.PROCESS_MODE_DISABLED
