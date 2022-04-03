extends KinematicBody2D

const MAX_DIST : int = 200
const MAX_DIST_SQR : int = MAX_DIST * MAX_DIST
const MAX_SPEED : int = 400
const ACCELERATION : int = 1600

const Explosion := preload("res://scenes/characters/player/Explosion.tscn")

var velocity := Vector2()
var is_pulling := false
var see_player := true

onready var player := $Player
onready var line := $Line2D
onready var death_timer := $DeathTimer
onready var raycast := $RayCast2D


func _ready() -> void:
	get_tree().call_group("needs_player", "set_player", player)
	player.position = position
	player.set_as_toplevel(true)


func _process(delta: float) -> void:
	is_pulling = Input.is_action_pressed("pull")
	_set_line()


func _physics_process(delta: float) -> void:
	raycast.cast_to = player.position - position
	raycast.force_raycast_update()
	_set_see_player(not raycast.is_colliding())
	var desired_velocity := Vector2()
	if is_pulling:
		desired_velocity = MAX_SPEED * position.direction_to(player.position)
	velocity = velocity.move_toward(desired_velocity, ACCELERATION * delta)
	move_and_slide(velocity)


func _set_line() -> void:
	line.points[1] = player.position - position


func _set_see_player(val: bool) -> void:
	if see_player == val:
		return
	set_process(val)
	if not val:
		is_pulling = false
	line.visible = val
	see_player = val


func _on_Player_died() -> void:
	var explosion = Explosion.instance()
	explosion.position = player.position
	get_parent().add_child(explosion)
	player.position = position
	line.hide()
	if see_player:
		death_timer.start()


func _on_DeathTimer_timeout() -> void:
	player.position = position
	player.respawn()
	line.show()
