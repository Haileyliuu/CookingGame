extends Label
@onready var label: Label = $"."


func _process(_delta: float) -> void:
	label.text = ":" + str(Inventory.cat_hunted_meat) + "\n:" + str(Inventory.cat_chopped_meat)
