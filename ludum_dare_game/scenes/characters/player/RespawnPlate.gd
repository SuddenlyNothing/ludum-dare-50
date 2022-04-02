extends KinematicBody2D

const MAX_DIST : int = 300
const MAX_DIST_SQR : int = MAX_DIST * MAX_DIST
const MAX_SPEED : int = 200
const ACCELERATION : int = 400

const Explosion := preload("res://scenes/characters/player/Explosion.tscn")

var velocity := Vector2()

onready var player := $Player
onready var line := $Line2D
onready var death_timer := $DeathTimer


func _ready() -> void:
	get_tree().call_group("needs_player", "set_player", player)
	player.position = position
	player.set_as_toplevel(true)


func _process(delta: float) -> void:
	line.points[1] = player.position - position


func _physics_process(delta: float) -> void:
	if not is_instance_valid(player):
		return
	var desired_velocity := Vector2()
	if position.distance_squared_to(player.position) > MAX_DIST_SQR:
		desired_velocity = MAX_SPEED * position.direction_to(player.position)
	velocity = velocity.move_toward(desired_velocity, ACCELERATION * delta)
	move_and_slide(velocity)


func _on_Player_died() -> void:
	var explosion = Explosion.instance()
	explosion.position = player.position
	get_parent().add_child(explosion)
	player.position = position
	death_timer.start()


func _on_DeathTimer_timeout() -> void:
	player.respawn()
