extends Label
@onready var label: Label = $"."


func _process(_delta: float) -> void:
	label.text = ":" + str(Inventory.dog_hunted_meat) + "\n:" + str(Inventory.dog_chopped_meat)
