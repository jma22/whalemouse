extends EnemyBase

class_name SquidMinion


@onready var enemy_idle_state : EnemyIdleState = $StateMachine/EnemyIdleState
@onready var hurt_state : EnemyHurtState = $StateMachine/EnemyHurtState
@onready var enemy_walk_state : EnemyWalkState = $StateMachine/EnemyWalkState
# @onready var retreat_state : EnemyRetreatState = $StateMachine/EnemyRetreatState
@onready var approach_state : EnemyPursuitState = $StateMachine/EnemyPursuitState
# @onready var attack_state : EnemyStaticAttackState = $StateMachine/EnemyStaticAttackState
# @onready var peaceful_state : EnemyPeacefulState = $StateMachine/EnemyPeacefulState
# @onready var charge_state : EnemyChargeStateBase = $StateMachine/EnemyChargeState
@onready var enemy_attack_state :EnemyAttackParentState = $StateMachine/EnemyAttackParentState

# @onready var enemy_jump_attack_state : EnemyJumpAttackState = $StateMachine/EnemyJumpAttackState
# @onready var enemy_jump_attack_charge_state : EnemyJumpAttackChargeState = $StateMachine/EnemyJumpAttackChargeState
# var pursuit_range : float = 3.0
var attack_range : float = 0.1



func setup(player : CharacterBody3D, map : NavigationRegion3D) -> void:
	enemy_idle_state.set_idle_duration(0.5)
	initial_state = enemy_idle_state
	super.setup(player, map)


func check_state() -> void:
	# pass
	if state_machine.current_state.is_complete:
		if state_machine.current_state == enemy_idle_state:
			state_machine.set_state(approach_state)
		elif state_machine.current_state == approach_state:
			state_machine.set_state(approach_state, true)
		elif state_machine.current_state == enemy_attack_state:
			state_machine.set_state(approach_state)

	else:
		check_range()

func check_range() -> void:
	var distance_to_player : float = global_transform.origin.distance_to(player.global_transform.origin)
	if distance_to_player <= attack_range:
		state_machine.set_state(enemy_attack_state)

	
func on_staggered() -> void:
	hurt_state.set_idle_duration(0.3)
	state_machine.set_state(hurt_state)

func on_hitbox_hit() -> void:
	on_die(DamageInfo.new())
