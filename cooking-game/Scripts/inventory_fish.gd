extends Label
@onready var label: Label = $"."


func _process(_delta: float) -> void:
	label.text = ":" + str(Inventory.cat_hunted_meat) + "\n:" + str(Inventory.cat_chopped_meat)


func _on_pause_button_pressed() -> void:
	pass # Replace with function body.
