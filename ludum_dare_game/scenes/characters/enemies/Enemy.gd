extends KinematicBody2D

const ACCELERATION : int = 300
const MAX_SPEED : int = 150
const PUSH_FORCE : int = 1000
const ROTATE_SPEED : int = 10
const ATTACK_DAMAGE : int = 5

var velocity := Vector2()
var potential_targets := {}
var targets := {}
var target : Node
var attack_targets := {}
var do_update_target := true

onready var soft_collision := $SoftCollision
onready var update_target_timer := $UpdateTargetTimer
onready var sprite := $Sprite
onready var attack_timer := $AttackTimer
onready var vision_cast := $VisionCast


func _physics_process(delta: float) -> void:
	var desired_velocity := Vector2()
	if is_instance_valid(target):
		desired_velocity = position.direction_to(target.position) * MAX_SPEED
		set_facing(desired_velocity, delta)
	velocity = velocity.move_toward(desired_velocity, ACCELERATION * delta)
	velocity += PUSH_FORCE * delta * soft_collision.get_push_dir()
	move_and_slide(velocity)
	if do_update_target:
		update_potential_targets()


func set_facing(dir: Vector2, delta: float) -> void:
	sprite.rotation = lerp_angle(sprite.rotation, dir.angle() - PI / 2, ROTATE_SPEED * delta)


func update_potential_targets() -> void:
	for i in potential_targets:
		vision_cast.cast_to = i.position - position
		vision_cast.force_raycast_update()
		if vision_cast.is_colliding():
			targets.erase(i)
			if target == i:
				if targets.size() > 0:
					set_target_to_closest()
				else:
					target = null
		else:
			targets[i] = 0
			if targets.size() == 1:
				set_target_to_closest()
				update_target_timer.start()


func set_target_to_closest() -> void:
	var min_target : Node
	var min_dist = null
	for i in targets:
		var new_dist := position.distance_squared_to(i.position)
		if min_dist == null or new_dist < min_dist:
			min_target = i
			min_dist = new_dist
	target = min_target


func attack() -> void:
	for i in attack_targets:
		i.hit(ATTACK_DAMAGE, position.direction_to(i.position))


func _on_Vision_body_entered(body: Node) -> void:
	potential_targets[body] = 0


func _on_Vision_body_exited(body: Node) -> void:
	potential_targets.erase(body)
	targets.erase(body)


func _on_UpdateTargetTimer_timeout() -> void:
	set_target_to_closest()


func _on_Hitbox_body_entered(body: Node) -> void:
	if not body.is_in_group("hittable"):
		return
	if attack_targets.empty():
		attack_timer.start()
		attack_targets[body] = 0
		attack()
	else:
		attack_targets[body] = 0


func _on_Hitbox_body_exited(body: Node) -> void:
	if not body.is_in_group("hittable"):
		return
	attack_targets.erase(body)
	if attack_targets.empty():
		attack_timer.stop()


func _on_AttackTimer_timeout() -> void:
	attack()
