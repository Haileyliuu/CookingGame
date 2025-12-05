extends MiniGame

# -------------------------
# FOR TESTING
# -------------------------
#extends Node2D
#var player_id: String = "dog"
# -------------------------

signal chop_button_state(state)
signal chop_done(player_id : String)

@export var CHOPS_REQUIRED: int = 5
var CHOPS_PER_STAGE: int = 1

var ui_font = load("res://Art/Fonts/MADE Tommy Soft Bold PERSONAL USE.otf")

var ingredient_id: int = 1
var chops_left: int = 0 
var chopping_active: bool = false
var player_chop_art: Dictionary = {}
var shake_tween: Tween
var difficulty_stage := 2 
var original_placeholder_pos: Vector2
var warning_tween: Tween = null


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

var cat_progress_texture = preload("res://Art/ChoppingUI/ProgressBarCat.png")
var dog_progress_texture = preload("res://Art/ChoppingUI/ProgressBarDog.png")

var cat_chop_stages = {}
var dog_chop_stages = {}

@onready var placeholder: Sprite2D = $CanvasLayer1/ChopPlaceholder
@onready var background: Sprite2D = $CanvasLayer1/Background
@onready var knife = $CanvasLayer2/Knife
@onready var chop_sound: AudioStreamPlayer2D = $ChopSound
@onready var chop_progress: TextureProgressBar = $CanvasLayer3/ProgressBar
@onready var screen_size = get_viewport_rect().size
@onready var prompt_label = $CanvasLayer3/PromptLabel

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	$CanvasLayer3.layer = 3
	$CanvasLayer2.layer = 2
	$CanvasLayer1.layer = 1
	
	#var main := get_tree().root.get_child(2)
	#main.threshold_passed.connect(threshold_passed)
	_load_textures()
	
	await get_tree().process_frame
	_position_progress_bar()
	
	display_background()
	original_placeholder_pos = placeholder.position
	
	start_chopping(player_id, 1)
	
	# TEST
	await get_tree().create_timer(10).timeout
	threshold_passed(1)   
	print("stage 2")

	await get_tree().create_timer(10).timeout
	threshold_passed(0)   
	print("stage 3")
	# END TEST


# -------------------------
# DISPLAY SET UP
# -------------------------
func _position_progress_bar(): 
	var viewport := get_viewport_rect().size 
	var bar_size := chop_progress.size
	chop_progress.scale = Vector2(0.7, 0.6)
	var scaled_width := chop_progress.size.x * chop_progress.scale.x
	chop_progress.position.x = viewport.x * 0.5 - scaled_width * 0.5
	chop_progress.position.y = viewport.y * 0.005


func display_background():
	var screen := get_viewport_rect().size

	if background:
		var bg_scale := screen.y / 1080.0
		background.centered = true
		background.position = screen * 0.5
		background.scale = Vector2.ONE * bg_scale

	if placeholder:
		var chop_scale := screen.y / 1080.0 * 0.7 
		placeholder.centered = true
		placeholder.position = screen * 0.5
		placeholder.scale = Vector2.ONE * chop_scale

	if knife:
		var knife_scale_factor := screen.y / 1080.0 * 0.7  # adjust 0.9 to taste
		knife.scale = Vector2.ONE * knife_scale_factor
		knife.position = placeholder.position + Vector2(0, -screen.y * 0.1)

	if chop_progress:
		var bar_scale_x := 0.7
		var bar_scale_y := 0.6
		chop_progress.scale = Vector2(bar_scale_x, bar_scale_y)
		var scaled_width := chop_progress.size.x * chop_progress.scale.x
		chop_progress.position.x = screen.x * 0.5 - scaled_width * 0.5
		chop_progress.position.y = screen.y * 0.005

func _set_up_player_visuals() -> void:
	if player_id == "cat":
		player_chop_art = cat_chop_stages
		if ResourceLoader.exists(cat_background_path):
			background.texture = load(cat_background_path)
		knife.texture = cat_knife_path
		chop_progress.texture_progress = cat_progress_texture
	else:
		player_chop_art = dog_chop_stages
		if ResourceLoader.exists(dog_background_path):
			background.texture = load(dog_background_path)
		knife.texture = dog_knife_path
		chop_progress.texture_progress = dog_progress_texture


# -------------------------
# SHAKING
# -------------------------
func _update_shake_feedback(stage_index: int) -> void:
	if shake_tween and shake_tween.is_running():
		shake_tween.kill()

	# how this works:
	#   if threshold hits 1, shaking is enabed
	#   if placeholder is index 1, shaking starts
	if difficulty_stage > 1 or stage_index < 1:
		placeholder.position = original_placeholder_pos
		return

	var shake_amount := 6.0 + (stage_index * 3.0)
	var duration := 0.07

	shake_tween = get_tree().create_tween().set_loops()
	shake_tween.tween_property(
		placeholder,
		"position",
		original_placeholder_pos + Vector2(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount)
		),
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


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

	var stage_index := int(chops_done / CHOPS_PER_STAGE)

	stage_index = clamp(stage_index, 0, stages.size() - 1)

	placeholder.texture = stages[stage_index]

	_update_shake_feedback(stage_index)


func _load_textures():
	for id in cat_chop_paths.keys():
		cat_chop_stages[id] = []
		for path in cat_chop_paths[id]:
			if ResourceLoader.exists(path):
				cat_chop_stages[id].append(load(path))

	for id in dog_chop_paths.keys():
		dog_chop_stages[id] = []
		for path in dog_chop_paths[id]:
			if ResourceLoader.exists(path):
				dog_chop_stages[id].append(load(path))


# -------------------------
# TRACK DIFFICULTY
# -------------------------
func threshold_passed(threshold: int):
	difficulty_stage = threshold
	
	match threshold:
		2:
			CHOPS_REQUIRED = 5
			CHOPS_PER_STAGE = 1
		1:
			CHOPS_REQUIRED = 10
			CHOPS_PER_STAGE = 2
		0:
			CHOPS_REQUIRED = 15
			CHOPS_PER_STAGE = 3

	chop_progress.max_value = CHOPS_REQUIRED
	reset_chop()


# -------------------------
# GAME START
# -------------------------
func start_chopping(player: String, ingredient: int = 1) -> void:
	player_id = player
	ingredient_id = ingredient
	chops_left = CHOPS_REQUIRED
	chopping_active = true

	_set_up_player_visuals()

	chop_progress.max_value = CHOPS_REQUIRED
	_update_progress_immediately(0)

	_update_placeholder_art()

# randomized ver??
func start_chopping_random(player: String) -> void:
	var table: Dictionary = cat_chop_stages if player == "cat" else dog_chop_stages
	var keys: Array = table.keys()

	if keys.is_empty():
		push_warning("No chop art found for %s" % player)
		return

	var ingredient: int = keys[randi() % keys.size()]
	start_chopping(player, ingredient)


# -------------------------
# RESTART GAME
# -------------------------
func reset_chop() -> void:
	chops_left = CHOPS_REQUIRED
	chopping_active = true
	chop_progress.max_value = CHOPS_REQUIRED
	_update_progress_immediately(0)
	_update_placeholder_art()


func _input(event: InputEvent) -> void:
	#if Inventory.get(player_id + "_meat") <= 0:
		#create_inventory_warning()
		#return

	if Inventory.get(player_id + "_hunted_meat") <= 0 && event.is_action_pressed(player_id+"_chop"):
		if warning_tween && warning_tween.is_running():
			await warning_tween.finished
 
		print("no more meat")
		print("Dog hunted meat:", Inventory.dog_hunted_meat)
		print("Dog chopped meat:", Inventory.dog_chopped_meat)
		chopping_active = false
		create_inventory_warning()

	# ------------------------
	# CHOPPING ACTIVE
	# ------------------------
	if chopping_active:
		if player_id == "cat" and event.is_action_pressed("cat_chop"):
			_handle_chop()
		elif player_id == "dog" and event.is_action_pressed("dog_chop"):
			_handle_chop()
		return 

	# ------------------------
	# CHOPPING FINISHED — allow reset
	# ------------------------
	if chops_left <= 0:
		if (player_id == "cat" and event.is_action_pressed("cat_select")) or \
		   (player_id == "dog" and event.is_action_pressed("dog_select")):
			reset_chop()
			Inventory.set(player_id + "_hunted_meat", Inventory.get(player_id + "_hunted_meat") - 1)
			Inventory.set(player_id + "_chopped_meat", Inventory.get(player_id + "_chopped_meat") + 1)


# -------------------------
# THE ACTUAL CHOPPING
# -------------------------
func _handle_chop() -> void:
	if knife and knife.has_method("chop"):
		knife.chop()

	chop_sound.stop()
	chop_sound.pitch_scale = randf_range(0.9, 1.1)
	chop_sound.play()

	chops_left -= 1
	_update_placeholder_art()
	_animate_progress_bar()

	if chops_left <= 0:
		chopping_active = false
		emit_signal("chop_done", player_id)

	print("Dog hunted meat:", Inventory.dog_hunted_meat)
	print("Dog chopped meat:", Inventory.dog_chopped_meat)


# -------------------------
# PROGRESS BAR
# -------------------------
func _animate_progress_bar() -> void:
	var target := float(CHOPS_REQUIRED - chops_left)
	var t = get_tree().create_tween()
	t.tween_property(chop_progress, "value", target, 0.1)

func _update_progress_immediately(value: int) -> void:
	chop_progress.value = float(value)


# -------------------------
# INVENTORY CHECK
# -------------------------
func create_inventory_warning():
	var warning_label = prompt_label

	warning_label.visible = true
	warning_label.modulate.a = 1.0

	if player_id == "dog":
		warning_label.text = "Ran out of meat! \nGo hunt!"
	else:
		warning_label.text = "Ran out of fish! \nGo fish!"

	warning_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var my_font = load("res://Art/Fonts/MADE Tommy Soft Bold PERSONAL USE.otf")
	warning_label.add_theme_font_override("font", my_font)
	warning_label.add_theme_font_size_override("font_size", 50 * screen_size.y / 1080)
	warning_label.add_theme_color_override("font_color", Color(0.954, 0.954, 0.954, 1.0))
	warning_label.add_theme_constant_override("outline_size", 20)
	warning_label.add_theme_color_override("font_outline_color", Color(0.202, 0.283, 0.599, 1.0))

	await get_tree().process_frame
	var label_size = warning_label.size
	warning_label.position = Vector2(
		screen_size.x / 2 - label_size.x / 2,
		1.75 * screen_size.y / 3 - label_size.y / 2
	)

	# Fade out
	if warning_tween and warning_tween.is_running():
		warning_tween.kill()
	warning_tween = get_tree().create_tween()
	warning_tween.tween_property(warning_label, "modulate:a", 0.0, 1.2)
	await warning_tween.finished

	warning_label.visible = false



	
	
