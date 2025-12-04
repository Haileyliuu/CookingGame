extends Label
@onready var label: Label = $"."


func _process(_delta: float) -> void:
	label.text = "Cow Inventory: " + str(Inventory.dog_meat)
