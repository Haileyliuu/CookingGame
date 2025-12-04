class_name InteractMinigame extends InteractionArea

#You have to drag in the minigame you want this to connect to
@export var minigame: MiniGame

#Called when the player interacts with the button
func _ready():
	interact = func(player_id: String):
		match player_id:
			"cat":
				if GameStats.cat_state == GameStats.PlayerStates.SABOTAGE:
					return
			"dog":
				if GameStats.dog_state == GameStats.PlayerStates.SABOTAGE:
					return
		if who_can_interact == minigame.player_id:
			interact_with_button()

#If the minigame is the parent of this button, end the minigame
#otherwise start the minigame
func interact_with_button():
	if parent.is_in_group("Minigame"):
		minigame.end_minigame()
	else:
		minigame.start_minigame()
