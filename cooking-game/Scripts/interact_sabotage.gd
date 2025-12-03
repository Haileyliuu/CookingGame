class_name IntSabo extends InteractionArea

@export var player_id: String

var interact: Callable = func(player_id: String):
	if player_id == self.player_id:
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
