class_name BugCatcher extends Node2D

var player_id: String

var input_direction: Vector2

@onready var anim_player = $AnimationPlayer
@onready var area = $Area2D
@onready var parent = get_parent()
const my_scene: PackedScene = preload("res://Scenes/Minigames/sabotoge/bug_catcher.tscn")

var caught_bug := false

func _ready() -> void:
	area.area_entered.connect(on_bug_enter)

static func create(pid: String) -> BugCatcher:
	var newCatcher = my_scene.instantiate()
	newCatcher.player_id = pid
	return newCatcher

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(player_id + "_select"):
		anim_player.play("swing")

func on_bug_enter(bug: Area2D):
	if bug is Cockroach and not caught_bug:
		caught_bug = true
		print("Caught!")
		#TODO when the bug is caught, replace the bug net with the bug and set a boolean
		#that makes you able to put shit in the shit
		parent.remove_child(self)
		parent.add_child(Cockroach.catch(Vector2(0,0)))
		queue_free()
	
