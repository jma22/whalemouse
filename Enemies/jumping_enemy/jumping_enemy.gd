extends EnemyBase

class_name JumpingEnemy


@onready var enemy_idle_state : EnemyIdleState = $StateMachine/EnemyIdleState
@onready var hurt_state : EnemyHurtState = $StateMachine/EnemyHurtState
# @onready var retreat_state : EnemyRetreatState = $StateMachine/EnemyRetreatState
# @onready var approach_state : EnemyPursuitState = $StateMachine/EnemyPursuitState
# @onready var attack_state : EnemyAttackState = $StateMachine/EnemyAttackState
# @onready var peaceful_state : EnemyPeacefulState = $StateMachine/EnemyPeacefulState
# @onready var charge_state : EnemyChargeStateBase = $StateMachine/EnemyChargeState

@onready var attack_state : EnemyAttackParentState = $StateMachine/EnemyAttackParentState

# @onready var enemy_spawn_state : EnemySpawnState = $StateMachine/EnemySpawnState

# @onready var enemy_ink_attack_state : EnemyInkAttackState = $StateMachine/EnemyInkAttackState
var pursuit_range : float = 3.0
var attack_range : float = 1.5

var boss_health : BossHealth


func setup(player : CharacterBody3D, map : NavigationRegion3D) -> void:
	initial_state = enemy_idle_state
	super.setup(player, map)

# func link_boss_health(boss_health : BossHealth) -> void:
# 	self.boss_health = boss_health
# 	boss_health.setup("Schkwid", initial_health)

# func link_spawner(enemy_spawner : EnemySpawner) -> void:
# 	enemy_spawn_state.link_spawner(enemy_spawner)

func check_state() -> void:
	# pass
	if state_machine.current_state.is_complete:
		if state_machine.current_state == enemy_idle_state:
			state_machine.set_state(attack_state)
		# elif state_machine.current_state == enemy_jump_attack_state:
		# 	enemy_idle_state.set_idle_duration(randf() * 1.0 + 0.5)
		# 	state_machine.set_state(enemy_idle_state)
		elif state_machine.current_state == attack_state:
			state_machine.set_state(enemy_idle_state)


func on_hit(attacker_hitbox : Hitbox) -> void:
	super(attacker_hitbox)
	boss_health.update_health(health_component.current_health)

func on_die() -> void:
	super.on_die()
	boss_health.hide()
