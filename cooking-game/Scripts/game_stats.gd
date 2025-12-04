extends Node

@onready var minigame = false
# These states tell the game where the cat and dog are
enum PlayerStates {KITCHEN, HUNTING, CHOPPING, ASSEMBLY, SABOTAGE, COCKROACH}
var dog_state: PlayerStates
var cat_state: PlayerStates


var cat_score: int = 0
var dog_score: int = 0

var cat_stats := { "Dishes Made" : 0,
					"Dishes Served" : 0,
					"Satisfied Customers" : 0,
					"Cockroaches Served" : 0,
					"Dishes Sabotaged": 0}

var dog_stats := { "Dishes Made" : 0,
					"Dishes Served" : 0,
					"Satisfied Customers" : 0,
					"Cockroaches Served" : 0,
					"Dishes Sabotaged": 0}


func _ready() -> void:
	dog_state = PlayerStates.KITCHEN
	cat_state = PlayerStates.KITCHEN

func _process(_delta: float) -> void:
	#print("D: " + str(dog_state))
	#print("C: " + str(cat_state))
	pass
