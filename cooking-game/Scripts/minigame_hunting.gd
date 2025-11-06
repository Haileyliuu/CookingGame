extends MiniGame

@onready var arrow: Sprite2D = $Arrow

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		print("shoot pressed!")
		arrow.launch()
		
