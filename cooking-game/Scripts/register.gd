extends Sprite2D

@onready var interaction_area = $InteractionArea
signal delivered_dish()


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	

func _on_interact(player_id):
	if player_id != interaction_area.who_can_interact:
		return
	var player: Player = get_tree().get_first_node_in_group(player_id)
	if player.meal != null:
		delivered_dish.emit(player.meal.cockroach)
		player.meal.queue_free()
