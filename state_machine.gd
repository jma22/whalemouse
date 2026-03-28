extends Node
class_name StateMachine

var current_state : State = null

func set_state(new_state: State, force :bool = false) -> void:
	if current_state != new_state or force:
		if current_state != null:
			current_state.exit()
		current_state = new_state
		current_state.init()
		current_state.enter()

# func get_states
