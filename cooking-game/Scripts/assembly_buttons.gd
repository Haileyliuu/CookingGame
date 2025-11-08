extends Control

var player_id := ""
var buttons := {}
var default_positions := {}

const NORMAL_COLOR := Color(1, 1, 1)
var pressed_shader = preload("res://Shaders/buttonPressed.gdshader")
const PRESS_OFFSET := Vector2(0, 5)

var dog_buttons = [
	preload("res://Art/AssemblyUI/CheeseButton.png"),
	preload("res://Art/AssemblyUI/PattyButton.png"),
	preload("res://Art/AssemblyUI/LettuceButton.png"),
	preload("res://Art/AssemblyUI/TomatoButton.png")
]


func _ready() -> void:
	# do nothing until player_id is set
	pass


func setup_buttons():
	buttons = {
		player_id + "_up": $UpButton,
		player_id + "_down": $DownButton,
		player_id + "_left": $LeftButton,
		player_id + "_right": $RightButton
	}

	default_positions.clear()
	var i = 0
	for action in buttons.keys():
		default_positions[action] = buttons[action].position
		buttons.get(action).texture = dog_buttons.get(i)
		i += 1 


func _process(_delta: float) -> void:
	if buttons.is_empty():
		return

	for action in buttons.keys():
		var sprite = buttons[action]
		var base_pos = default_positions[action]

		if Input.is_action_pressed(action):
			sprite.material = ShaderMaterial.new()
			sprite.material.shader = pressed_shader
			sprite.position = base_pos + PRESS_OFFSET
		else:
			sprite.material = null
			sprite.position = base_pos


func _on_minigame_assembly_player(p: Variant) -> void:
	player_id = p
	setup_buttons()
