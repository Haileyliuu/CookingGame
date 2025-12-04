extends Control

var player_id := ""
var buttons := {}
var default_positions := {}

const NORMAL_COLOR := Color(1, 1, 1)
var pressed_shader = preload("res://Shaders/buttonPressed.gdshader")
const PRESS_OFFSET := Vector2(0, 5)

var select_button_state = "plate"  # can be plate, check, or send

var dog_button_art = [
	preload("res://Art/AssemblyUI/DogButtons/CheeseButton.png"),
	preload("res://Art/AssemblyUI/DogButtons/PattyButton.png"),
	preload("res://Art/AssemblyUI/DogButtons/LettuceButton.png"),
	preload("res://Art/AssemblyUI/DogButtons/TomatoButton.png"),
	preload("res://Art/AssemblyUI/DogButtons/ShiftPlateButton.png"),
	preload("res://Art/AssemblyUI/DogButtons/ShiftCheckButton.png"),
	preload("res://Art/AssemblyUI/DogButtons/ShiftSendButton.png")
]

var cat_button_art = [
	preload("res://Art/AssemblyUI/CatButtons/CrabButton.png"),
	preload("res://Art/AssemblyUI/CatButtons/FishButton.png"),
	preload("res://Art/AssemblyUI/CatButtons/CucumberButton.png"),
	preload("res://Art/AssemblyUI/CatButtons/AvocadoButton.png"),
	preload("res://Art/AssemblyUI/CatButtons/EMatButton.png"),
	preload("res://Art/AssemblyUI/CatButtons/ECheckButton.png"),
	preload("res://Art/AssemblyUI/CatButtons/ESendButton.png")
]

@onready var select_button = $SelectButton

func _ready() -> void:
	# do nothing until player_id is set
	pass

func setup_buttons():
	buttons = {
		player_id + "_up": $UpButton,
		player_id + "_down": $DownButton,
		player_id + "_left": $LeftButton,
		player_id + "_right": $RightButton, 
		player_id + "_select": select_button
	}

	default_positions.clear()
	var i = 0
	for action in buttons.keys():
		default_positions[action] = buttons[action].position
		buttons.get(action).texture = get(player_id + "_button_art").get(i)
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


func _on_minigame_assembly_player_signal(p: Variant) -> void:
	player_id = p
	setup_buttons()


func _on_minigame_assembly_select_button_state(s: Variant) -> void:
	if s == "plate":
		select_button.texture = get(player_id + "_button_art")[4]
	elif s == "check":
		select_button.texture = get(player_id + "_button_art")[5]
	elif s == "send":
		select_button.texture = get(player_id + "_button_art")[6]
		
