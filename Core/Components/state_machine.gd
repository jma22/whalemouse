extends Node3D
class_name StateMachine

var owner_state : State = null
var current_state : State = null
@export var debug : bool = true

func set_state(new_state: State, force :bool = false) -> void:
	if current_state != new_state or force:
		var current_path : String = ""
		if debug:
			current_path = current_state.get_full_state_path() if current_state != null else "null"
			
		if current_state != null:
			current_state.deep_exit()
		current_state = new_state
		current_state.init(self)
		current_state.enter()
		if debug:
			var debug_str : String = "State change: " + current_path + " -> " + current_state.get_full_state_path()
			if Config.is_enabled("debug_state_log"):
				DebugLog.dbg("State[%s]" % DebugLog.entity_name(get_parent()), debug_str)
				print(debug_str)


# func _process(delta: float) -> void:
# 	print(current_state)

func is_root() -> bool:
	return owner_state == null
