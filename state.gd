@abstract
class_name State extends Node

var start_time : float = 0.0
var is_complete : bool = false
var state_machine : StateMachine = null
var player : Player = null

# var child_state : State = null


# @abstract func enter() -> void
# @abstract func exit() -> void
# @abstract func run(delta: float) -> void
# @abstract func fixed_run(delta: float) -> void

func deep_run(delta: float) -> void:
	run(delta)
	# if child_state != null:
	# 	child_state.deep_run(delta)

func deep_fixed_run(delta: float) -> void:
	fixed_run(delta)
	# if child_state != null:
	# 	child_state.deep_fixed_run(delta)

func enter() -> void:
	pass

func exit() -> void:
	pass

func run(delta: float) -> void:
	pass

func fixed_run(delta: float) -> void:
	pass

func get_elapsed_time() -> float:
	return Time.get_ticks_msec() / 1000.0 - start_time

func init() -> void:
	start_time = Time.get_ticks_msec() / 1000.0
	# state_machine = StateMachine.new()
	# add_child(state_machine)
	is_complete = false

func set_player(p: Player) -> void:
	player = p
