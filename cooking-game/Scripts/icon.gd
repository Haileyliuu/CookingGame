class_name icon
extends Sprite2D

#hitbox = the thing that takes damage
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("_arrow"):
		print("arrow entered")
		queue_free()


	
func _animal():
	pass
