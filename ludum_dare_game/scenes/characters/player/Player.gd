extends KinematicBody2D

const MAX_SPEED : int = 200

var input := Vector2()


func _process(delta: float) -> void:
	_set_input()


func _set_input() -> void:
	input = Input.get_vector("left", "right", "up", "down")


func move() -> void:
	move_and_slide(input * MAX_SPEED)
