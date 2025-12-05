class_name IntSabo extends InteractionArea

@export var pid: String

func _ready():
	interact = func(player_id: String):
		var player = get_tree().get_first_node_in_group(player_id)
		if player_id == who_can_interact and player.meal == null:
			interact_with_button(player_id)

func interact_with_button(player_id: String):
	print("sabo")
	var player: Player = get_tree().get_first_node_in_group(player_id)
	var states = GameStats.PlayerStates
	var player_state = GameStats.get(player_id + "_state")
	if player.meal != null:
		return
	if player_state == GameStats.PlayerStates.SABOTAGE:
		print(player_state)
		GameStats.set(player_id + "_state", states.KITCHEN)
		player.bug_net.hide()
	else:
		GameStats.set(player_id + "_state", states.SABOTAGE)
		print(player_state)
		print(GameStats.PlayerStates.SABOTAGE)
		player.bug_net.show()
