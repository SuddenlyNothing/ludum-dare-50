extends StateMachine


func _ready() -> void:
	add_state("idle")
	add_state("walk")
	add_state("death")
	call_deferred("set_state", "idle")


# Contains state logic.
func _state_logic(delta : float) -> void:
	match state:
		states.idle:
			pass
		states.walk:
			parent.move()
		states.death:
			pass

# Return value will be used to change state.
func _get_transition(delta : float):
	match state:
		states.idle:
			if parent.input != Vector2():
				return states.walk
		states.walk:
			if parent.input == Vector2():
				return states.idle
		states.death:
			pass
	return null

# Called on entering state.
# new_state is the state being entered.
# old_state is the state being exited.
func _enter_state(new_state : String, old_state) -> void:
	match new_state:
		states.idle:
			pass
		states.walk:
			pass
		states.death:
			set_death(true)

# Called on exiting state.
# old_state is the state being exited.
# new_state is the state being entered.
func _exit_state(old_state, new_state : String) -> void:
	match old_state:
		states.idle:
			pass
		states.walk:
			pass
		states.death:
			set_death(false)


func set_death(is_dead: bool) -> void:
	if is_dead:
		parent.emit_signal("died")
	parent.visible = not is_dead
	parent.set_process(not is_dead)
	set_physics_process(not is_dead)
	parent.body_collision.call_deferred("set_disabled", is_dead)
	parent.hitbox_collision.call_deferred("set_disabled", is_dead)
