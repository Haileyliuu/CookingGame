extends Sprite2D

@onready var interaction_area = $InteractionArea
signal delivered_dish()

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	emit_signal("delivered_dish")
