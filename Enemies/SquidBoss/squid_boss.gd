extends EnemyBase

class_name SquidBoss


@onready var enemy_idle_state : EnemyIdleState = $StateMachine/EnemyIdleState
@onready var hurt_state : EnemyHurtState = $StateMachine/EnemyHurtState
@onready var retreat_state : EnemyRetreatState = $StateMachine/EnemyRetreatState
@onready var approach_state : EnemyPursuitState = $StateMachine/EnemyPursuitState
@onready var attack_state : EnemyAttackState = $StateMachine/EnemyAttackState
@onready var peaceful_state : EnemyPeacefulState = $StateMachine/EnemyPeacefulState
@onready var charge_state : EnemyChargeState = $StateMachine/EnemyChargeState

@onready var enemy_jump_attack_state : EnemyJumpAttackState = $StateMachine/EnemyJumpAttackState
@onready var enemy_jump_attack_charge_state : EnemyJumpAttackChargeState = $StateMachine/EnemyJumpAttackChargeState

@onready var enemy_spawn_state : EnemySpawnState = $StateMachine/EnemySpawnState

@onready var enemy_ink_attack_state : EnemyInkAttackState = $StateMachine/EnemyInkAttackState
var pursuit_range : float = 3.0
var attack_range : float = 1.5

var boss_health : BossHealth


func setup(player : CharacterBody3D, map : NavigationRegion3D) -> void:
	# initial_health = 2
	initial_state = enemy_ink_attack_state
	super.setup(player, map)

func link_boss_health(boss_health : BossHealth) -> void:
	self.boss_health = boss_health
	boss_health.setup("Schkwid", initial_health)

func link_spawner(enemy_spawner : EnemySpawner) -> void:
	enemy_spawn_state.link_spawner(enemy_spawner)

func check_state() -> void:
	# pass
	if state_machine.current_state.is_complete:
		if state_machine.current_state == enemy_jump_attack_charge_state:
			state_machine.set_state(enemy_jump_attack_state)
		# elif state_machine.current_state == enemy_jump_attack_state:
		# 	enemy_idle_state.set_idle_duration(randf() * 1.0 + 0.5)
		# 	state_machine.set_state(enemy_idle_state)
		elif state_machine.current_state == enemy_jump_attack_state:
			state_machine.set_state(sample_next_state())
		else:
			state_machine.set_state(enemy_jump_attack_charge_state)


func sample_next_state() -> State:
	var rand = randf()
	if rand < 0.5:
		return enemy_jump_attack_charge_state
	elif rand < 0.8:
		return enemy_ink_attack_state
	else:
		return enemy_spawn_state

func check_range() -> void:
	var distance_to_player : float = global_transform.origin.distance_to(player.global_transform.origin)
	if distance_to_player <= attack_range:
		if state_machine.current_state != attack_state:
			state_machine.set_state(charge_state)
	elif distance_to_player <= pursuit_range:
		if state_machine.current_state != attack_state:
			if randf() < 0.75:
				state_machine.set_state(retreat_state)
			else:
				state_machine.set_state(approach_state)
	else:
		if state_machine.current_state != enemy_idle_state and state_machine.current_state != charge_state:
			state_machine.set_state(peaceful_state)

func on_hit(damage: int) -> void:
	super(damage)
	boss_health.update_health(health_component.current_health)

func on_die() -> void:
	super.on_die()
	boss_health.hide()
# func on_staggered() -> void:
	# pass
	# hurt_state.set_idle_duration(0.3)
	# state_machine.set_state(hurt_state)
