extends Node

@onready var minigame = false
# These states tell the game where the cat and dog are
enum PlayerStates {KITCHEN, HUNTING, CHOPPING, ASSEMBLY, SABOTAGE}
var dog_state: PlayerStates
var cat_state: PlayerStates

func _ready() -> void:
	dog_state = PlayerStates.KITCHEN
	cat_state = PlayerStates.KITCHEN

func _process(delta: float) -> void:
	#print("D: " + str(dog_state))
	#print("C: " + str(cat_state))
	pass
