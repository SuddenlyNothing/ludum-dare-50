extends StaticBody2D

signal lost


func _on_Endpoint_body_entered(body: Node) -> void:
	emit_signal("lost")
