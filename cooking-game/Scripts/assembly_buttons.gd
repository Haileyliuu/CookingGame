extends Control

var player_id := ""
var buttons := {}
var default_positions := {}

const NORMAL_COLOR := Color(1, 1, 1)
const PRESSED_COLOR := Color(0.7, 0.7, 0.7)
const PRESS_OFFSET := Vector2(0, 5)

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
	for action in buttons.keys():
		default_positions[action] = buttons[action].position


func _process(_delta: float) -> void:
	if buttons.is_empty():
		return

	for action in buttons.keys():
		var sprite = buttons[action]
		var base_pos = default_positions[action]

		if Input.is_action_pressed(action):
			sprite.modulate = PRESSED_COLOR
			sprite.position = base_pos + PRESS_OFFSET
		else:
			sprite.modulate = NORMAL_COLOR
			sprite.position = base_pos


func _on_minigame_assembly_player(p: Variant) -> void:
	player_id = p
	setup_buttons()
