extends Node

@onready var minigame = false
# These states tell the game where the cat and dog are
enum {KITCHEN, HUNTING, CHOPPING, ASSEMBLY}
var dog_state
var cat_state

func _ready() -> void:
	dog_state = KITCHEN
	cat_state = KITCHEN

func _process(delta: float) -> void:
	match dog_state:
		KITCHEN:
			print(dog_state)
		HUNTING:
			print(dog_state)
		CHOPPING:
			print(dog_state)
		ASSEMBLY:
			print(dog_state)
			
	match cat_state:
		KITCHEN:
			print(cat_state)
		HUNTING:
			print(cat_state)
		CHOPPING:
			print(cat_state)
		ASSEMBLY:
			print(cat_state)
