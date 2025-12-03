extends Node2D # use extends minigame when fr

signal chop_done(player_id : String)
var player_id: String = "cat" # for testing purposes

@export var CHOPS_REQUIRED : int = 5

var ingredient_id: int = 1
var chops_left: int = 0 
var chopping_active: bool = false
var player_chop_art: Dictionary = {}

# REPLACE PATHS
var cat_chop_paths := {
	1: [
		"res://Art/SushiArt/Avocado.png",
		"res://Art/SushiArt/Cucumber.png",
		"res://Art/SushiArt/Fish.png",
		"res://Art/SushiArt/ImitationCrab.png",
		"res://Art/SushiArt/SeaweedRice.png"
	]
}

# REPLACE PATHS
var dog_chop_paths := {
	1: [
		"res://Art/BurgerArt/BottomBun.PNG",
		"res://Art/BurgerArt/Cheese.PNG",
		"res://Art/BurgerArt/Lettuce.PNG",
		"res://Art/BurgerArt/Patty.PNG",
		"res://Art/BurgerArt/Tomato.PNG"
	]
}

var cat_background_path := "res://Art/Objects/CatBoard.png"
var dog_background_path := "res://Art/Objects/DogBoard.png"

var cat_chop_stages = {}
var dog_chop_stages = {}

@onready var placeholder: Sprite2D = $ChopPlaceholder
@onready var background: Sprite2D = $Background
@onready var knife = $Knife
@onready var chop_label: Label = $ChopLabel
@onready var prompt_label: Label = $PromptLabel
@onready var chop_sound: AudioStreamPlayer2D = $ChopSound
@onready var chop_progress: TextureProgressBar = $ProgressBarUI/ProgressBar


func _ready():
	placeholder.centered = true
	placeholder.position = get_viewport_rect().size * 0.5
	_load_textures()
	_center_background() # centering the bg
	_center_placeholder() 
	background.z_index = -999 # being super safe that the bg is in the bg
	start_chopping(player_id, 1) # auto-starts testing


func _center_background():
	if background:
		background.centered = true
		background.position = get_viewport_rect().size * 0.5


func _center_placeholder():
	if placeholder:
		placeholder.centered = true
		placeholder.position = get_viewport_rect().size * 0.5


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
	_update_label()
	prompt_label.text = "%s: Chop the food!" % player_id.capitalize()

	_update_placeholder_art()

# --------------------------------------------------------------------
func reset_chop() -> void:
	chops_left = CHOPS_REQUIRED
	chopping_active = true
	_update_progress_immediately(0)
	_update_label()
	prompt_label.text = "%s: Chop the food!" % player_id.capitalize()
	_update_placeholder_art()

# --------------------------------------------------------------------
func _input(event: InputEvent) -> void:
	if not chopping_active:
		return
	
	# reset button for "shift" or "e"
	if event.is_action_pressed("dog_select") or event.is_action_pressed("cat_select"):
		reset_chop()
		return

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
	_update_label()
	_update_placeholder_art()
	_animate_progress_bar()

	if chops_left <= 0:
		chopping_active = false
		prompt_label.text = "%s finished chopping!" % player_id.capitalize()
		emit_signal("chop_done", player_id)

# --------------------------------------------------------------------
func _animate_progress_bar() -> void:
	var target := float(CHOPS_REQUIRED - chops_left)
	var t = get_tree().create_tween()
	t.tween_property(chop_progress, "value", target, 0.1)

func _update_progress_immediately(value: int) -> void:
	chop_progress.value = float(value)

func _update_label() -> void:
	chop_label.text = "Chops left: %d" % chops_left

# --------------------------------------------------------------------
func _set_up_player_visuals() -> void:
	if player_id == "cat":
		player_chop_art = cat_chop_stages
		if ResourceLoader.exists(cat_background_path):
			background.texture = load(cat_background_path)
	else:
		player_chop_art = dog_chop_stages
		if ResourceLoader.exists(dog_background_path):
			background.texture = load(dog_background_path)

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




## ChopMinigame.gd
#extends MiniGame
## If you don't have a MiniGame class, replace the above with `extends Node2D`.
#
#signal chop_done(player_id : String)
#
#@export var CHOPS_REQUIRED : int = 5
#
## State
#var player_id : String = ""       # "cat" or "dog" - set via start_chopping
#var ingredient_id : int = 1       # which ingredient we're chopping (1..n)
#var chops_left : int = 0
#var chopping_active : bool = false
#
## Art tables (each entry is an array of textures for each chop stage)
#var cat_chop_stages : Dictionary = {
	## example ingredient 1 has 5 stage textures (stage 0..4)
	#1 : [
		#preload("res://Art/SushiArt/Cucumber_Stage1.png"),
		#preload("res://Art/SushiArt/Cucumber_Stage2.png"),
		#preload("res://Art/SushiArt/Cucumber_Stage3.png"),
		#preload("res://Art/SushiArt/Cucumber_Stage4.png"),
		#preload("res://Art/SushiArt/Cucumber_Stage5.png"),
	#]
	## add more ingredients as needed
#}
#
#var dog_chop_stages : Dictionary = {
	#1 : [
		#preload("res://Art/BurgerArt/Tomato_Stage1.png"),
		#preload("res://Art/BurgerArt/Tomato_Stage2.png"),
		#preload("res://Art/BurgerArt/Tomato_Stage3.png"),
		#preload("res://Art/BurgerArt/Tomato_Stage4.png"),
		#preload("res://Art/BurgerArt/Tomato_Stage5.png"),
	#]
	## add more ingredients as needed
#}
#
## Backgrounds per player (optional)
#var cat_background = preload("res://Art/SushiArt/ChoppingBoard.png")
#var dog_background = preload("res://Art/BurgerArt/ChoppingBoard.png")
#
## Runtime selected table
#var player_chop_art : Dictionary = {}
#
## Node references (adjust node paths to your scene)
#@onready var placeholder : Sprite2D = $ChopPlaceholder
#@onready var background : Sprite2D = $Background
#@onready var knife = $Knife
#@onready var chop_label : Label = $ChopLabel
#@onready var prompt_label : Label = $PromptLabel
#@onready var chop_sound : AudioStreamPlayer = $ChopSound
#@onready var chop_progress : ProgressBar = $ProgressBarUI/ProgressBar
#
#func _ready() -> void:
	## Do not auto-start. Call start_chopping(player, ingredient) from the parent / scene manager.
	#chops_left = 0
	#chopping_active = false
	#placeholder.visible = true
	#_update_progress_immediately(0)
	#prompt_label.text = "Waiting..."
#
## Call this to begin chopping for a player and specific ingredient (ingredient defaults to 1)
#func start_chopping(player : String, ingredient : int = 1) -> void:
	#player_id = player
	#ingredient_id = ingredient
	#chops_left = CHOPS_REQUIRED
	#chopping_active = true
#
	## choose art and background based on player
	#_set_up_player_visuals()
#
	## init UI
	#_update_progress_immediately(0)
	#chop_progress.max_value = CHOPS_REQUIRED
	#_update_label()
	#prompt_label.text = "%s: Chop the food!" % player_id.capitalize()
#
	## set initial placeholder texture
	#_update_placeholder_art()
#
## Reset the current chopping attempt (keeps the same player & ingredient)
#func reset_chop() -> void:
	#chops_left = CHOPS_REQUIRED
	#chopping_active = true
	#_update_progress_immediately(0)
	#_update_label()
	#prompt_label.text = "%s: Chop the food!" % player_id.capitalize()
	#_update_placeholder_art()
#
#func _input(event : InputEvent) -> void:
	## Allow reset key even if not currently active (to restart quickly)
	#if player_id != "":
		#if event.is_action_pressed(player_id + "_select"):
			## reset key mapping: "cat_select" or "dog_select"
			#reset_chop()
			#return
#
	## Chop handling only when active
	#if not chopping_active:
		#return
#
	## Player-specific chop input
	#if player_id == "dog" and event.is_action_pressed("dog_chop"):
		#_handle_chop()
	#elif player_id == "cat" and event.is_action_pressed("cat_chop"):
		#_handle_chop()
#
#func _handle_chop() -> void:
	## Knife feedback (if your knife node has a chop method; otherwise animate it separately)
	#if knife and knife.has_method("chop"):
		#knife.chop()
	## Play chop sound with small pitch variance
	#if chop_sound:
		#chop_sound.stop()
		#chop_sound.pitch_scale = randf_range(0.95, 1.08)
		#chop_sound.play()
#
	## Decrement chops and update visuals
	#chops_left -= 1
	#_update_label()
	#_update_placeholder_art()
	#_animate_progress_bar()
#
	## If finished
	#if chops_left <= 0:
		#chopping_active = false
		#prompt_label.text = "%s finished chopping!" % player_id.capitalize()
		#emit_signal("chop_done", player_id)
#
## Update progress bar value quickly (tween)
#func _animate_progress_bar() -> void:
	#var target_value := CHOPS_REQUIRED - chops_left
	#var t = get_tree().create_tween()
	#t.tween_property(chop_progress, "value", float(target_value), 0.12).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
#
## Set the progress bar instantly (used on start/reset)
#func _update_progress_immediately(value : int) -> void:
	#chop_progress.value = float(value)
#
#func _update_label() -> void:
	#chop_label.text = "Chops left: %d" % chops_left
#
## Choose correct art table + background according to player
#func _set_up_player_visuals() -> void:
	#if player_id == "cat":
		#player_chop_art = cat_chop_stages
		#if background and cat_background:
			#background.texture = cat_background
	#else:
		#player_chop_art = dog_chop_stages
		#if background and dog_background:
			#background.texture = dog_background
#
## Update placeholder texture according to how many chops done
#func _update_placeholder_art() -> void:
	## Guard: ensure we have an art table and an entry for this ingredient_id
	#if not player_chop_art.has(ingredient_id):
		## fallback: if you want a default texture, set it here; otherwise hide placeholder
		#placeholder.visible = false
		#return
	#placeholder.visible = true
#
	#var stages : Array = player_chop_art[ingredient_id]
	## stage index: number of chops already performed (0-based)
	#var done := CHOPS_REQUIRED - chops_left
	#if done < 0:
		#done = 0
	## Clamp index into stages array range
	#var idx := int(clamp(done, 0, stages.size() - 1))
	#placeholder.texture = stages[idx]
#
## Optional convenience: start chopping with a random ingredient (call from parent)
#func start_chopping_random(player : String) -> void:
	#var table := (player == "cat") ? cat_chop_stages : dog_chop_stages
	#var keys := table.keys()
	#if keys.size() == 0:
		#push_warning("No chop art configured for player %s" % player)
		#return
	#var random_ing := keys[randi() % keys.size()]
	#start_chopping(player, random_ing)
#
#
#### Minigame to chop ingredients.
####
#### Keep track of the player ID (dog/cat). Press the 
#### assigned key until a set number of chops is achieved.
#### Then the food is chopped and the minigame finishes.
####
##
#### Cat = 'S' key
#### Dog = down arrow key
#### Number of chops = 5
##
###extends MiniGame
##extends Node2D # remove this
##
##signal chop_done(player)
##
##const CHOPS_REQUIRED := 5
##
##var player_id : String = "dog" # remove this
##var chops_left : int = 0
##var chopping_active : bool = false
##var player_food_art
##
##@onready var chop_label = $ChopLabel
##@onready var prompt_label = $PromptLabel
##@onready var chop_sound = $ChopSound
##@onready var knife = $Knife
##@onready var chop_progress = $ProgressBarUI/ProgressBar
##
### texture, height, offset
##var cat_food_art = {
	##1 : [preload("res://Art/SushiArt/ImitationCrab.png"), 50],
	##2 : [preload("res://Art/SushiArt/Fish.png"), 40],
	##3 : [preload("res://Art/SushiArt/Cucumber.png"), 50],
	##4 : [preload("res://Art/SushiArt/Avocado.png"), 50],
	##5 : [preload("res://Art/SushiArt/SeaweedRice.png"), 40, -180],
##}
##
##var dog_food_art = {
	##1 : [preload("res://Art/BurgerArt/Cheese.PNG"), 50],
	##2 : [preload("res://Art/BurgerArt/Patty.PNG"), 82],
	##3 : [preload("res://Art/BurgerArt/Lettuce.PNG"), 60],
	##4 : [preload("res://Art/BurgerArt/Tomato.PNG"), 60],
	##5 : [preload("res://Art/BurgerArt/BottomBun.PNG"), 70],
##}
##
##func start_chopping(player: String):
	##player_id = player
	##chops_left = CHOPS_REQUIRED
	##chopping_active = true
##
	##chop_progress.value = 0
	##chop_progress.max_value = CHOPS_REQUIRED
##
	##prompt_label.text = "%s: Chop the food!" % player.capitalize()
	##
	##update_label()
	##set_up_player_food_art()
##
##
##func _input(event: InputEvent) -> void:
	##if not chopping_active:
		##return
##
	##if player_id == "dog" and event.is_action_pressed("dog_chop"):
		##handle_chop()
##
	##elif player_id == "cat" and event.is_action_pressed("cat_chop"):
		##handle_chop()
##
##
##func handle_chop():
	##knife.chop()
	##
	##chop_sound.stop()
	##chop_sound.pitch_scale = randf_range(0.9, 1.1)
	##chop_sound.play()
	##
	##chops_left -= 1
	##update_label()
##
	##if chops_left <= 0:
		##chopping_active = false
		##prompt_label.text = "%s finished chopping!" % player_id.capitalize()
		##emit_signal("chop_done", player_id)
##
##
##func update_label():
	##chop_label.text = "Chops left: %d" % chops_left
##
	##var target_value = CHOPS_REQUIRED - chops_left
	##var tween = get_tree().create_tween()
	##tween.tween_property(chop_progress, "value", target_value, 0.1)
##
##
##func set_up_player_food_art():
	##if player_id == "cat":
		##player_food_art = cat_food_art
	##else:
		##player_food_art = dog_food_art
##
#### Dog is hardcoded to begin when the tscn plays.
##func _ready():
	##start_chopping("dog")
##
###TODO:
	###have placeholder images update for every chop
	###have a reset button "e" for cat "shift" for dog
	###have background and images change depending on player id
