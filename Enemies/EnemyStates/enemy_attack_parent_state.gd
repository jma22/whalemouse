extends State
class_name EnemyAttackParentState

@export var charge_state : EnemyChargeStateBase
@export var attack_state : State
@export var cooldown_state : State

func enter() -> void:
	charge_state.attack_state = attack_state
	state_machine.set_state(charge_state)

func run(_delta: float) -> void:
	check_state()

func check_state() -> void:
	var child_state : State = get_child_state()
	print(child_state)
	print(child_state.is_complete)
	if child_state.is_complete:
		if child_state == charge_state:
			state_machine.set_state(attack_state)
		elif child_state == attack_state:
			cooldown_state.set_idle_duration(randf() * 1.0 + 0.5)
			state_machine.set_state(cooldown_state)
		elif child_state == cooldown_state:
			is_complete = true


			
