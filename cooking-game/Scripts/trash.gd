extends Node2D

var int_area: InteractionArea

func _ready() -> void:
	int_area = self.get_child(0)
	int_area.interact = Callable(self, "_throw_away")

func _throw_away(player_id):
	var player: Player = get_tree().get_first_node_in_group(player_id)
	var cockroach = player.player_cockroach
	var meal = player.meal
	if meal != null:
		meal.queue_free()
	elif cockroach != null:
		cockroach.queue_free()
		GameStats.set(player_id + "_state", GameStats.PlayerStates.KITCHEN)
