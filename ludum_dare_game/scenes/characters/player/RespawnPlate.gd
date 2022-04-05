extends KinematicBody2D

signal died

const MAX_DIST : int = 200
const MAX_DIST_SQR : int = MAX_DIST * MAX_DIST
const MAX_SPEED : int = 420
const ACCELERATION : int = 1000
const MAX_KNOCKBACK : int = 5000

const Explosion := preload("res://scenes/characters/player/Explosion.tscn")

var velocity := Vector2()
var is_pulling := false
var see_player := true

onready var player := $Player
onready var line := $Line2D
onready var death_timer := $DeathTimer
onready var raycast := $RayCast2D
onready var hud := $HUD
onready var line_tween : Tween = $LineTween
onready var spawn := $SpawnSFX
onready var anim_sprite := $AnimatedSprite
onready var hit_timer := $HitTimer
onready var drag_sfx := $DragSFX


func _ready() -> void:
	player.position = position
	player.set_as_toplevel(true)


func _process(_delta: float) -> void:
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
	drag_sfx.volume_db = linear2db(velocity.length() / MAX_SPEED)
	velocity = move_and_slide(velocity)


func hit(dmg: float, dir: Vector2 = Vector2()) -> void:
	velocity += dmg / 100 * MAX_KNOCKBACK * dir
	if hud.add_health(-dmg):
		emit_signal("died")
		var explosion = Explosion.instance()
		explosion.position = position
		get_parent().call_deferred("add_child", explosion)
		var explosion2 = Explosion.instance()
		explosion2.position = player.position
		get_parent().call_deferred("add_child", explosion2)
		queue_free()
	else:
		anim_sprite.play("damage")
		hit_timer.start()


func _set_line() -> void:
	_set_line_pos(player.position - position)


func _set_see_player(val: bool) -> void:
	if see_player == val:
		return
	set_process(val)
	if not val:
		is_pulling = false
	set_line_width_t(int(val) * 10)
	see_player = val


func set_line_width_t(val: float) -> void:
	line_tween.remove_all()
	line_tween.interpolate_property(line, "width", null, val, 0.1)
	line_tween.start()


func _set_line_pos(pos: Vector2) -> void:
	line.points[1] = pos
	player.position = pos + position


func _on_Player_died() -> void:
	var explosion = Explosion.instance()
	explosion.position = player.position
	get_parent().add_child(explosion)
	set_process(false)
	is_pulling = false
	if see_player:
		line_tween.remove_all()
		line.width = 10
		line_tween.interpolate_method(self, "_set_line_pos", line.points[1], Vector2(),
				death_timer.wait_time, Tween.TRANS_CUBIC)
		line_tween.start()
		death_timer.start()
	else:
		emit_signal("died")


func _on_DeathTimer_timeout() -> void:
	player.position = position
	player.respawn()
	spawn.play()
	set_process(true)


func _on_HitTimer_timeout() -> void:
	anim_sprite.play("default")
