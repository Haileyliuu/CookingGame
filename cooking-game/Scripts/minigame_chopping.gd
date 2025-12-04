extends Node2D # use extends minigame when fr

signal chop_done(player_id : String)
var player_id: String = "dog" # for testing purposes

@export var CHOPS_REQUIRED : int = 5

var ui_font = load("res://Art/Fonts/MADE Tommy Soft Bold PERSONAL USE.otf")

var ingredient_id: int = 1
var chops_left: int = 0 
var chopping_active: bool = false
var player_chop_art: Dictionary = {}


# REPLACE PATHS
var cat_chop_paths := {
	1: [
		"res://Art/SushiArt/ChoppingFish/ChopFish1.PNG",
		"res://Art/SushiArt/ChoppingFish/ChopFish2.PNG",
		"res://Art/SushiArt/ChoppingFish/ChopFish3.PNG",
		"res://Art/SushiArt/ChoppingFish/ChopFish4.PNG",
		"res://Art/SushiArt/ChoppingFish/ChopFish5.PNG",
		"res://Art/SushiArt/ChoppingFish/ChopFish6.PNG"
	]
}

# REPLACE PATHS
var dog_chop_paths := {
	1: [
		"res://Art/BurgerArt/ChoppingCow/ChopCow1.PNG",
		"res://Art/BurgerArt/ChoppingCow/ChopCow2.PNG",
		"res://Art/BurgerArt/ChoppingCow/ChopCow3.PNG",
		"res://Art/BurgerArt/ChoppingCow/ChopCow4.PNG",
		"res://Art/BurgerArt/ChoppingCow/ChopCow5.PNG",
		"res://Art/BurgerArt/ChoppingCow/ChopCow6.PNG"
	]
}


var cat_background_path := "res://Art/MinigameArt/CatCounter.png"
var dog_background_path := "res://Art/MinigameArt/DogCounter.png"

var cat_knife_path = preload("res://Art/SushiArt/ChoppingFish/CatKnife.PNG")
var dog_knife_path = preload("res://Art/BurgerArt/ChoppingCow/DogKnife.PNG")

var cat_chop_stages = {}
var dog_chop_stages = {}

@onready var placeholder: Sprite2D = $CanvasLayer1/ChopPlaceholder
@onready var background: Sprite2D = $CanvasLayer1/Background
@onready var knife = $CanvasLayer2/Knife
@onready var prompt_label: Label = $CanvasLayer3/PromptLabel
@onready var chop_sound: AudioStreamPlayer2D = $ChopSound
@onready var chop_progress: TextureProgressBar = $CanvasLayer3/ProgressBar
@onready var screen_size = get_viewport_rect().size


func _ready():
	$CanvasLayer3.layer = 3
	$CanvasLayer2.layer = 2
	$CanvasLayer1.layer = 1
	
	placeholder.centered = true
	placeholder.position = get_viewport_rect().size * 0.5
	
	#_apply_ui_font()
	_load_textures()
	
	await get_tree().process_frame
	#_position_prompt_label()
	_position_progress_bar()
	
	
	_center_background() # centering the bg
	_center_placeholder()
	display_background()
	
	start_chopping(player_id, 1) # auto-starts testing
	


# --------------------------------------------------------------------
func _apply_ui_font():
	var size_factor := get_viewport_rect().size.y / 1080.0

	prompt_label.add_theme_font_override("font", ui_font)
	prompt_label.add_theme_font_size_override("font_size", 60 * size_factor)

# --------------------------------------------------------------------
func _position_progress_bar(): 
	var viewport := get_viewport_rect().size 
	var bar_size := chop_progress.size
	chop_progress.scale = Vector2(0.7, 0.6)
	var scaled_width := chop_progress.size.x * chop_progress.scale.x
	chop_progress.position.x = viewport.x * 0.5 - scaled_width * 0.5
	chop_progress.position.y = viewport.y * 0.005

func _position_prompt_label():
	var viewport := get_viewport_rect().size
	var width := prompt_label.get_combined_minimum_size().x

	prompt_label.global_position = Vector2(
		viewport.x * 0.5 - width * 0.5,
		viewport.y * 0.9
	)

# --------------------------------------------------------------------
func _center_background():
	if background:
		background.centered = true
		background.position = get_viewport_rect().size * 0.5

func _center_placeholder():
	if placeholder:
		placeholder.centered = true
		placeholder.position = get_viewport_rect().size * 0.5

func display_background():
	var screen := get_viewport_rect().size

	# -------------------------
	# BACKGROUND BOARD
	# -------------------------
	if background:
		var bg_scale := screen.y / 1080.0
		background.centered = true
		background.position = screen * 0.5
		background.scale = Vector2.ONE * bg_scale

	# -------------------------
	# CHOPPING ART (placeholder)
	# -------------------------
	if placeholder:
		var chop_scale := screen.y / 1080.0 * 0.7  # adjust 0.8 to taste
		placeholder.centered = true
		placeholder.position = screen * 0.5
		placeholder.scale = Vector2.ONE * chop_scale

	# -------------------------
	# KNIFE
	# -------------------------
	if knife:
		var knife_scale_factor := screen.y / 1080.0 * 0.7  # adjust 0.9 to taste
		knife.scale = Vector2.ONE * knife_scale_factor
		knife.position = placeholder.position + Vector2(0, -screen.y * 0.1)

	# -------------------------
	# PROGRESS BAR
	# -------------------------
	if chop_progress:
		var bar_scale_x := 0.7
		var bar_scale_y := 0.6
		chop_progress.scale = Vector2(bar_scale_x, bar_scale_y)
		var scaled_width := chop_progress.size.x * chop_progress.scale.x
		chop_progress.position.x = screen.x * 0.5 - scaled_width * 0.5
		chop_progress.position.y = screen.y * 0.005

	# -------------------------
	# PROMPT LABEL
	# -------------------------
	if prompt_label:
		var width := prompt_label.get_combined_minimum_size().x
		prompt_label.global_position = Vector2(screen.x * 0.5 - width * 0.5, screen.y * 0.9)

# --------------------------------------------------------------------
func _load_textures():
	# Load cat chop stages safely
	for id in cat_chop_paths.keys():
		cat_chop_stages[id] = []
		for path in cat_chop_paths[id]:
			if ResourceLoader.exists(path):
				cat_chop_stages[id].append(load(path))

	# Load dog chop stages safely
	for id in dog_chop_paths.keys():
		dog_chop_stages[id] = []
		for path in dog_chop_paths[id]:
			if ResourceLoader.exists(path):
				dog_chop_stages[id].append(load(path))


# --------------------------------------------------------------------
func start_chopping(player: String, ingredient: int = 1) -> void:
	player_id = player
	ingredient_id = ingredient
	chops_left = CHOPS_REQUIRED
	chopping_active = true

	_set_up_player_visuals()

	chop_progress.max_value = CHOPS_REQUIRED
	_update_progress_immediately(0)
	#prompt_label.text = "Chop chop!"

	_update_placeholder_art()


# --------------------------------------------------------------------
func reset_chop() -> void:
	chops_left = CHOPS_REQUIRED
	chopping_active = true
	_update_progress_immediately(0)
	_update_placeholder_art()
	#prompt_label.text = "Chop chop!"


# --------------------------------------------------------------------
func _input(event: InputEvent) -> void:
	if not chopping_active:
		return

	# Reset chopping for both players
	if (player_id == "cat" and event.is_action_pressed("cat_select")) or \
	   (player_id == "dog" and event.is_action_pressed("dog_select")):
		reset_chop()
		return

	# Normal chopping input
	if player_id == "cat" and event.is_action_pressed("cat_chop"):
		_handle_chop()
	elif player_id == "dog" and event.is_action_pressed("dog_chop"):
		_handle_chop()


# --------------------------------------------------------------------
func _handle_chop() -> void:
	if knife and knife.has_method("chop"):
		knife.chop()

	chop_sound.stop()
	chop_sound.pitch_scale = randf_range(0.95, 1.08)
	chop_sound.play()

	chops_left -= 1
	_update_placeholder_art()
	_animate_progress_bar()

	if chops_left <= 0:
		chopping_active = false
		#prompt_label.text = "Done!"
		emit_signal("chop_done", player_id)


# --------------------------------------------------------------------
func _animate_progress_bar() -> void:
	var target := float(CHOPS_REQUIRED - chops_left)
	var t = get_tree().create_tween()
	t.tween_property(chop_progress, "value", target, 0.1)


# --------------------------------------------------------------------
func _update_progress_immediately(value: int) -> void:
	chop_progress.value = float(value)


# --------------------------------------------------------------------
func _set_up_player_visuals() -> void:
	if player_id == "cat":
		player_chop_art = cat_chop_stages
		if ResourceLoader.exists(cat_background_path):
			background.texture = load(cat_background_path)
		knife.texture = cat_knife_path
	else:
		player_chop_art = dog_chop_stages
		if ResourceLoader.exists(dog_background_path):
			background.texture = load(dog_background_path)
		knife.texture = dog_knife_path
			


# --------------------------------------------------------------------
func _update_placeholder_art() -> void:
	if not player_chop_art.has(ingredient_id):
		placeholder.visible = false
		return

	var stages: Array = player_chop_art[ingredient_id]
	if stages.is_empty():
		placeholder.visible = false
		return

	placeholder.visible = true
	var chops_done: int = CHOPS_REQUIRED - chops_left
	var idx: int = clamp(chops_done, 0, stages.size() - 1)
	placeholder.texture = stages[idx]


# --------------------------------------------------------------------
func start_chopping_random(player: String) -> void:
	var table: Dictionary = cat_chop_stages if player == "cat" else dog_chop_stages
	var keys: Array = table.keys()

	if keys.is_empty():
		push_warning("No chop art found for %s" % player)
		return

	var ingredient: int = keys[randi() % keys.size()]
	start_chopping(player, ingredient)
