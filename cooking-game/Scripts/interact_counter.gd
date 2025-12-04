class_name IntCounter extends InteractionArea

func _ready():
	interact = func(player_id: String):
		if player_id == who_can_interact:
			interact_with_button(player_id)

func interact_with_button(player_id: String):
	pass
