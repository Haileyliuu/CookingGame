class_name InteractMinigame extends InteractionArea

#You have to drag in the minigame you want this to connect to
@export var minigame: MiniGame

#Called when the player interacts with the button
var interact: Callable = func(player_id: String):
	if player_id == minigame.player_id:
		interact_with_button()

#If the minigame is the parent of this button, end the minigame
#otherwise start the minigame
func interact_with_button():
	if parent.is_in_group("Minigame"):
		minigame.end_minigame()
	else:
		minigame.start_minigame()
