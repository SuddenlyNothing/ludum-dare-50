extends Area2D


func _on_Explosion_body_entered(body: Node) -> void:
	body.queue_free()


func _on_Timer_timeout() -> void:
	queue_free()
