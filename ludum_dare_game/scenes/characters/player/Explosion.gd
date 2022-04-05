extends Area2D

onready var explosion_particles := $ExplosionParticles
onready var explosion_sfx := $ExplosionSFX
onready var collision_shape := $CollisionShape2D


func _ready() -> void:
	explosion_particles.play("explode")
	explosion_sfx.play()


func _on_Explosion_body_entered(body: Node) -> void:
	body.queue_free()


func _on_Timer_timeout() -> void:
	queue_free()


func _on_ExplosionParticles_frame_changed() -> void:
	match explosion_particles.frame:
		4:
			collision_shape.call_deferred("set_disabled", true)
