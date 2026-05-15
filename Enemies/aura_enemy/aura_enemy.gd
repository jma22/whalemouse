extends EnemyBase
class_name AuraEnemy

@onready var enemy_idle_state : EnemyIdleState = $StateMachine/EnemyIdleState
@onready var hurt_state : EnemyHurtState = $StateMachine/EnemyHurtState
# @onready var retreat_state : EnemyRetreatState = $StateMachine/EnemyRetreatState
@onready var attack_state : EnemyAttackParentState = $StateMachine/EnemyAttackParentState

@onready var peaceful_state : EnemyPeacefulState = $StateMachine/EnemyPeacefulState

@export var aura : FloorEffectBase
var cooldown_time : float = 2.0


func setup(player: CharacterBody3D, map: NavigationRegion3D) -> void:
	initial_state = enemy_idle_state
	super.setup(player, map)

func check_state() -> void:
	if not state_machine.current_state.is_complete and state_machine.current_state == hurt_state:
		return
	# check_range()
	if state_machine.current_state.is_complete:
		if state_machine.current_state == attack_state:
			enemy_idle_state.set_idle_duration(attack_state.attack_state.aura_time + get_cooldown_time())
			state_machine.set_state(enemy_idle_state)
		elif state_machine.current_state == enemy_idle_state:
			state_machine.set_state(attack_state)
		elif state_machine.current_state == hurt_state:
			state_machine.set_state(enemy_idle_state)


func on_staggered() -> void:
	hurt_state.set_idle_duration(0.3)
	state_machine.set_state(hurt_state)

func on_die(info: DamageInfo) -> void:
	super(info)
	aura.deactivate_aura()

func get_cooldown_time() -> float:
	return cooldown_time / get_speed_multiplier()
