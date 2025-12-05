extends Label
@onready var label: Label = $"."


func _process(_delta: float) -> void:
	label.text = "Fish: " + str(Inventory.cat_hunted_meat) + "\nChopped Fish: " + str(Inventory.cat_chopped_meat)
