extends Node2D

@onready var interact_label: Label = $InteractRange/InteractLabel

var curr_interactions := []
var can_interact := true

#Sabotage variables
var sabotage := false

@onready var player_id = owner.player_id
@onready var bug_net: BugCatcher = BugCatcher.create(player_id)
var who_can_interact

func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if ((event.is_action_pressed("cat_select") and player_id == "cat") 
	 or (event.is_action_pressed("dog_select") and player_id == "dog")):
		if can_interact and (who_can_interact == player_id or who_can_interact == "both"):
			if curr_interactions:
				can_interact = false
				interact_label.hide()
				
				await curr_interactions[0].interact.call()
				
				can_interact = true
				if (curr_interactions[0] is IntSabo):
					_handle_sabotage()
				
				await curr_interactions[0].interact.call(player_id)
				
				can_interact = true
#
func _handle_sabotage() -> void:
	if(GameStats.cat_state == GameStats.PlayerStates.SABOTAGE):
		print("removing")
		bug_net.queue_free()
	else:
		print("adding")
		bug_net = BugCatcher.create(player_id)
		add_child(bug_net)
		sabotage = true

func _process(_delta: float) -> void:		
	if curr_interactions and can_interact:
		curr_interactions.sort_custom(_sort_by_nearest)
		if curr_interactions[0].is_interactable:
			interact_label.text = curr_interactions[0].interact_name
			interact_label.show()
	else:
		interact_label.hide()
	
	#Don't mind me, I'm just here for rotating the little guy (bug net)
	if (Input.is_action_just_pressed(player_id + "_left") 
	or Input.is_action_just_pressed(player_id + "_right")
	or Input.is_action_just_pressed(player_id + "_up")
	or Input.is_action_just_pressed(player_id + "_down")):
		rotation = owner.input_direction.angle()
	
func _sort_by_nearest(area1, area2):
	var area1_dist = global_position.distance_to(area1.global_position)
	var area2_dist = global_position.distance_to(area2.global_position)
	return area1_dist < area2_dist


func _on_interact_range_area_entered(area: Area2D) -> void:
	if area is InteractionArea:
		curr_interactions.push_back(area)
		who_can_interact = area.who_can_interact
		print("entered collision")
	

func _on_interact_range_area_exited(area: Area2D) -> void:
	curr_interactions.erase(area)
