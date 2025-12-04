extends Label
@onready var label: Label = $"."


func _process(_delta: float) -> void:
	label.text = "Fish Inventory: " + str(Inventory.cat_meat)
