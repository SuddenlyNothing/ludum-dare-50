extends KinematicBody2D

const ACCELERATION : int = 300
const MAX_SPEED : int = 150
const PUSH_FORCE : int = 1000

var player : Node
var velocity := Vector2()

onready var soft_collision := $SoftCollision


func _ready() -> void:
	if not player:
		set_physics_process(false)


func set_player(val) -> void:
	player = val
	set_physics_process(true)


func _physics_process(delta: float) -> void:
	if not is_instance_valid(player):
		return
	velocity = velocity.move_toward(position.direction_to(player.position) * MAX_SPEED,
			ACCELERATION * delta)
	
	velocity += PUSH_FORCE * delta * soft_collision.get_push_dir()
	move_and_slide(velocity)
