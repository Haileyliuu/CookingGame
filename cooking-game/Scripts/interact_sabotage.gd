class_name IntSabo extends InteractionArea

@export var pid: String

func _ready():
	interact = func(player_id: String):
		if player_id == who_can_interact:
			interact_with_button(player_id)

func interact_with_button(player_id: String):
	print("sabo")
	match player_id:
		"cat":
			if GameStats.cat_state == GameStats.PlayerStates.SABOTAGE:
				GameStats.cat_state = GameStats.PlayerStates.KITCHEN
			else:
				GameStats.cat_state = GameStats.PlayerStates.SABOTAGE
		"dog":
			if GameStats.dog_state == GameStats.PlayerStates.SABOTAGE:
				GameStats.dog_state = GameStats.PlayerStates.KITCHEN
			else:
				GameStats.dog_state = GameStats.PlayerStates.SABOTAGE
