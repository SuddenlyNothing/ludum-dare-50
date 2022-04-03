extends KinematicBody2D

const ACCELERATION : int = 300
const MAX_SPEED : int = 150
const PUSH_FORCE : int = 1000
const ROTATE_SPEED : int = 10

var velocity := Vector2()
var targets := {}
var target : Node

onready var soft_collision := $SoftCollision
onready var update_target_timer := $UpdateTargetTimer
onready var sprite := $Sprite


func _physics_process(delta: float) -> void:
	var desired_velocity := Vector2()
	if target:
		desired_velocity = position.direction_to(target.position) * MAX_SPEED
		set_facing(desired_velocity, delta)
	velocity = velocity.move_toward(desired_velocity, ACCELERATION * delta)
	velocity += PUSH_FORCE * delta * soft_collision.get_push_dir()
	move_and_slide(velocity)


func set_facing(dir: Vector2, delta: float) -> void:
	sprite.rotation = lerp_angle(sprite.rotation, dir.angle() - PI / 2, ROTATE_SPEED * delta)


func set_target_to_closest() -> void:
	var min_target : Node
	var min_dist = null
	for i in targets:
		var new_dist := position.distance_squared_to(i.position)
		if min_dist == null or new_dist < min_dist:
			min_target = i
			min_dist = new_dist
	target = min_target


func _on_Vision_body_entered(body: Node) -> void:
	if not body.is_in_group("hittable"):
		return
	if targets.empty():
		update_target_timer.start()
		targets[body] = 0
		set_target_to_closest()
	else:
		targets[body] = 0


func _on_Vision_body_exited(body: Node) -> void:
	if not body.is_in_group("hittable"):
		return
	targets.erase(body)
	if targets.empty():
		update_target_timer.stop()
		target = null


func _on_UpdateTargetTimer_timeout() -> void:
	set_target_to_closest()


func _on_Hitbox_body_entered(body: Node) -> void:
	pass # Replace with function body.
