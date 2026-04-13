extends Node3D
class_name StateMachine

var current_state : State = null
@export var debug : bool = true

func set_state(new_state: State, force :bool = false) -> void:
	if debug:
		print("State change: ", current_state, " -> ", new_state)
	if current_state != new_state or force:
		if current_state != null:
			current_state.exit()
		current_state = new_state
		current_state.init()
		current_state.enter()

# func _process(delta: float) -> void:
# 	print(current_state)

func get_current_all_states() -> Array:
	if current_state == null:
		return []
	else:
		var states : Array = current_state.state_machine.get_current_all_states()
		states.append(current_state)
		return states
