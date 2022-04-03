extends Area2D

onready var explosion_particles := $ExplosionParticles


func _ready() -> void:
	explosion_particles.play("explode")


func _on_Explosion_body_entered(body: Node) -> void:
	body.queue_free()


func _on_Timer_timeout() -> void:
	queue_free()
