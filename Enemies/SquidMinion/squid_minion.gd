extends EnemyBase

class_name SquidMinion


@onready var enemy_idle_state : EnemyIdleState = $StateMachine/EnemyIdleState
@onready var hurt_state : EnemyHurtState = $StateMachine/EnemyHurtState
@onready var enemy_walk_state : EnemyWalkState = $StateMachine/EnemyWalkState
# @onready var retreat_state : EnemyRetreatState = $StateMachine/EnemyRetreatState
# @onready var approach_state : EnemyPursuitState = $StateMachine/EnemyPursuitState
@onready var attack_state : EnemyStaticAttackState = $StateMachine/EnemyStaticAttackState
# @onready var peaceful_state : EnemyPeacefulState = $StateMachine/EnemyPeacefulState
@onready var charge_state : EnemyChargeStateBase = $StateMachine/EnemyChargeState

# @onready var enemy_jump_attack_state : EnemyJumpAttackState = $StateMachine/EnemyJumpAttackState
# @onready var enemy_jump_attack_charge_state : EnemyJumpAttackChargeState = $StateMachine/EnemyJumpAttackChargeState
# var pursuit_range : float = 3.0
var attack_range : float = 0.2



func setup(player : CharacterBody3D, map : NavigationRegion3D) -> void:
	initial_health = 2
	enemy_idle_state.set_idle_duration(0.5)
	initial_state = enemy_idle_state
	super.setup(player, map)


func check_state() -> void:
	# pass
	if state_machine.current_state.is_complete:
		if state_machine.current_state == charge_state:
			state_machine.set_state(attack_state)
		elif state_machine.current_state == attack_state:
			var cooldown_time : float = 1.0
			enemy_idle_state.set_idle_duration(cooldown_time)
			state_machine.set_state(enemy_idle_state, true)
		else:
			var noise : Vector3 = Vector3(randf() - 0.5, 0, randf() - 0.5) * 0.1
			var target_position : Vector3 = player.global_transform.origin + noise
			enemy_walk_state.set_target_position(target_position)
			state_machine.set_state(enemy_walk_state, true)
	# 	if state_machine.current_state == charge_state:
	# 		state_machine.set_state(attack_state)
	# 	elif state_machine.current_state == attack_state:
	# 		enemy_idle_state.set_idle_duration(randf() * 1.0 + 0.5)
	# 		state_machine.set_state(enemy_idle_state)
	# 	elif state_machine.current_state == enemy_idle_state:
	# 		check_range()
	# 	elif state_machine.current_state == retreat_state:
	# 		check_range()
	# 	elif state_machine.current_state == approach_state:
	# 		check_range()
	# 	elif state_machine.current_state == hurt_state:
	# 		check_range()
	else:
		if state_machine.current_state == enemy_walk_state:
			check_range()
		# elif state_machine.current_state == approach_state:
		# 	state_machine.set_state(enemy_idle_state)
	# 	if state_machine.current_state == peaceful_state:	
	# 		check_range()
	# 	elif state_machine.current_state == approach_state:
	# 		state_machine.set_state(enemy_idle_state)


func check_range() -> void:
	var distance_to_player : float = global_transform.origin.distance_to(player.global_transform.origin)
	if distance_to_player <= attack_range:
		if state_machine.current_state != attack_state:
			# state_machine.set_state(attack_state)
			state_machine.set_state(charge_state)
	# elif distance_to_player <= pursuit_range:
	# 	if state_machine.current_state != attack_state:
	# 		if randf() < 0.75:
	# 			state_machine.set_state(retreat_state)
	# 		else:
	# 			state_machine.set_state(approach_state)
	# else:
	# 	if state_machine.current_state != enemy_idle_state and state_machine.current_state != charge_state:
	# 		state_machine.set_state(peaceful_state)

func on_staggered() -> void:
	hurt_state.set_idle_duration(0.3)
	state_machine.set_state(hurt_state)
