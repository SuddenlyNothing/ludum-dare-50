extends KinematicBody2D

signal died

const MAX_SPEED : int = 400

var input := Vector2()

onready var body_collision := $CollisionShape2D
onready var hitbox_collision := $Hitbox/CollisionShape2D
onready var player_states := $PlayerStates


func _process(delta: float) -> void:
	_set_input()


func _set_input() -> void:
	input = Input.get_vector("left", "right", "up", "down")


func move() -> void:
	move_and_slide(input * MAX_SPEED)


func _on_Hitbox_body_entered(body: Node) -> void:
	player_states.call_deferred("set_state", "death")


func respawn() -> void:
	player_states.call_deferred("set_state", "idle")


func hit() -> void:
	print("got hit!")
