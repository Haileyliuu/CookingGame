extends Control

@onready var resume_button: TextureButton = $PanelContainer/VBoxContainer/CanvasLayer/Resume
@onready var canvas_layer: CanvasLayer = $PanelContainer/VBoxContainer/CanvasLayer


func _ready() -> void:
	canvas_layer.visible = false
	$AnimationPlayer.play("RESET")

func _process(_delta: float) -> void:
	testEsc()
	
func resume():
	get_tree().paused = false
	canvas_layer.visible = false
	$AnimationPlayer.play_backwards("blur")
	
func pause():
	get_tree().paused = true
	canvas_layer.visible = true
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused: 
		resume()

func _on_resume_pressed() -> void:
	print("resume")
	resume()

func _on_restart_pressed() -> void:
	print("restart")
	resume()
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")


func _on_pause_button_pressed() -> void:
	if get_tree().paused:
		resume()
	else:
		pause()
