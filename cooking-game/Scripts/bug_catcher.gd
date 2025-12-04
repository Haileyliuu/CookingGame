class_name BugCatcher extends Node2D


var input_direction: Vector2

@onready var anim_player = $AnimationPlayer
@onready var area = $Area2D
@onready var player: Player = owner
const my_scene: PackedScene = preload("res://Scenes/Minigames/sabotoge/bug_catcher.tscn")

var caught_bug := false

func _ready() -> void:
	area.area_entered.connect(on_bug_enter)



func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed(player.player_id + "_select"):
		print("swing")
		anim_player.play("swing")

func on_bug_enter(bug: Area2D):
	if bug is Cockroach and not caught_bug:
		caught_bug = true
		print("Caught!")
		#TODO when the bug is caught, replace the bug net with the bug and set a boolean
		#that makes you able to put shit in the shit
		hide()
		bug.queue_free()
		var new_bug = Cockroach.catch(Vector2(0,0))
		player.add_child(new_bug)
		player.player_cockroach = new_bug
	
