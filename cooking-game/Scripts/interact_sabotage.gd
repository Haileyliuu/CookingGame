class_name IntSabo extends InteractionArea

@export var player_id: String

var interact: Callable = func(player_id: String):
	if player_id == self.player_id:
		interact_with_button(player_id)

func interact_with_button(player_id: String):
	match player_id:
		"cat":
			GameStats.cat_state = GameStats.PlayerStates.SABOTAGE
		"dog":
			GameStats.dog_state = GameStats.PlayerStates.SABOTAGE
