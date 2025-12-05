extends Label
@onready var label: Label = $"."


func _process(_delta: float) -> void:
	label.text = "Cow: " + str(Inventory.dog_hunted_meat) + "\nChopped Meat: " + str(Inventory.dog_chopped_meat)
