class_name Main extends Node2D

@onready var cat = %SushiCat
@onready var dog = %BurgerDog
@onready var background = $Background
@onready var sidepanels: SidePanels = $SidePanels

#Threshold Timer
var threshold_timer: Timer
const THRESHOLDS = 2
const THRESHOLD_WAIT_TIME = 180.0
var thresholds_left = THRESHOLDS
signal threshold_passed(threshold)


#Bug Timer beginning variables
var bug_timer: Timer
const BUG_MAX_TIME = 30.0
const BUG_MIN_TIME = 5.0



func _ready() -> void:
	GameStats.cat_score = 0
	GameStats.dog_score = 0
	GameStats.cat_state = GameStats.PlayerStates.KITCHEN
	GameStats.dog_state = GameStats.PlayerStates.KITCHEN
	Inventory.reset()
	bug_timer = Timer.new()
	bug_timer.one_shot = false 
	bug_timer.autostart = false
	bug_timer.wait_time = BUG_MAX_TIME
	add_child(bug_timer)
	bug_timer.timeout.connect(_bug_manager)
	bug_timer.start()
	
	threshold_timer = Timer.new()
	threshold_timer.one_shot = false
	threshold_timer.autostart = false
	threshold_timer.wait_time = THRESHOLD_WAIT_TIME
	add_child(threshold_timer)
	threshold_timer.timeout.connect(_threshold_passed.bind(THRESHOLDS))
	threshold_timer.start()

func _threshold_passed(threshold: int) -> void:
	threshold_timer.timeout.disconnect(_threshold_passed)
	print("Threshold passed")
	if threshold == 0:
		#end the game
		get_tree().change_scene_to_file("res://Scenes/UI/finish_screen.tscn")
		pass
	else:
		threshold_passed.emit(threshold)
		thresholds_left = thresholds_left - 1
		threshold_timer.timeout.connect(_threshold_passed.bind(thresholds_left))
		threshold_timer.start()

func _bug_manager() -> void:
	var random_pos: Vector2
	random_pos.x = randi_range(-500, 500)
	random_pos.y = randi_range(-500, 200)
	var bug = Cockroach.spawn(random_pos)
	#add bug to Navigation Region
	background.get_child(2).add_child(bug)
	

func _process(_delta: float) -> void:
	if GameStats.cat_state == GameStats.PlayerStates.KITCHEN or GameStats.cat_state == GameStats.PlayerStates.SABOTAGE:
		cat.process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		cat.process_mode = Node.PROCESS_MODE_DISABLED
	if GameStats.dog_state == GameStats.PlayerStates.KITCHEN or GameStats.dog_state == GameStats.PlayerStates.SABOTAGE:
		dog.process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		dog.process_mode = Node.PROCESS_MODE_DISABLED
