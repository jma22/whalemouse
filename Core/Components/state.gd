@abstract
class_name State extends Node

var start_time : float = 0.0
var is_complete : bool = false
var state_machine : StateMachine = null
var entity : CharacterBody3D = null
var elapsed_time : float = 0.0

# @abstract func enter() -> void
# @abstract func exit() -> void
# @abstract func run(delta: float) -> void
# @abstract func fixed_run(delta: float) -> void

func deep_run(delta: float) -> void:
	elapsed_time += delta
	run(delta)
	if get_child_state() != null:
		get_child_state().deep_run(delta)

func deep_fixed_run(delta: float) -> void:
	fixed_run(delta)
	if get_child_state() != null:
		get_child_state().deep_fixed_run(delta)

func enter() -> void:
	pass

func exit() -> void:
	pass

func run(_delta: float) -> void:
	pass

func fixed_run(_delta: float) -> void:
	pass

func get_elapsed_time() -> float:
	return elapsed_time

func init() -> void:
	start_time = Time.get_ticks_msec() / 1000.0
	elapsed_time = 0.0
	is_complete = false
	if state_machine == null:
		state_machine = StateMachine.new()
		add_child(state_machine)

func set_entity(e: CharacterBody3D) -> void:
	entity = e

func get_child_state() -> State:
	return state_machine.current_state
