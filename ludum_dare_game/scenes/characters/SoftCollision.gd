extends Area2D

var collision_area = null


func is_colliding() -> bool:
	return collision_area != null


func get_push_dir() -> Vector2:
	if not is_colliding():
		return Vector2()
	return collision_area.global_position.direction_to(global_position)


func _on_SoftCollision_area_entered(area: Area2D) -> void:
	if collision_area:
		return
	collision_area = area


func _on_SoftCollision_area_exited(area: Area2D) -> void:
	collision_area = null
