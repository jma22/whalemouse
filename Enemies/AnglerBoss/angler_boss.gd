extends EnemyBase


# @onready var enemy_idle_state : EnemyIdleState = $StateMachine/EnemyIdleState
# @onready var hurt_state : EnemyHurtState = $StateMachine/EnemyHurtState
# @onready var retreat_state : EnemyRetreatState = $StateMachine/EnemyRetreatState
# @onready var approach_state : EnemyPursuitState = $StateMachine/EnemyPursuitState
# # @onready var attack_state : EnemyAttackState = $StateMachine/EnemyAttackState
# @onready var peaceful_state : EnemyPeacefulState = $StateMachine/EnemyPeacefulState
# @onready var charge_state : EnemyChargeStateBase = $StateMachine/EnemyChargeState

# @onready var enemy_jump_attack_state : EnemyJumpAttackState = $StateMachine/EnemyJumpAttackState
# @onready var enemy_jump_attack_charge_state : EnemyJumpAttackChargeState = $StateMachine/EnemyJumpAttackChargeState

# @onready var enemy_spawn_state : EnemySpawnState = $StateMachine/EnemySpawnState
@onready var phase1state : State = $StateMachine/AnglerOneState
@onready var phase2state : State = $StateMachine/AnglerTwoState
@onready var phase3state : State = $StateMachine/AnglerThreeState
@onready var phase_change_state : PhaseChangeState = $StateMachine/PhaseChangeState


var minion_spawn_points : Array[Vector3] = []
var pillar_spawn_points : Array[Vector3] = []
# @onready var enemy_ink_attack_state : EnemyInkAttackState = $StateMachine/EnemyInkAttackState
var pursuit_range : float = 3.0
var attack_range : float = 1.5

var boss_health : BossHealth
var enemy_spawner : EnemySpawner
var current_phase : int = 0
var phase_state_order : Array[State]
var camera : Camera3D



func setup(player : CharacterBody3D, map : NavigationRegion3D) -> void:
	# initial_state = enemy_ink_attack_state
	super(player, map)
	health_component.max_health += StatCalculator.get_extra_boss_health() * 4
	health_component.current_health = health_component.max_health

	sprite_manager.render_priority = -1
	sprite_manager.material_overlay.render_priority = -1

	phase_change_state.set_idle_duration(3.0)
	phase_state_order = [phase1state, phase2state, phase3state]
	hurt_box.set_active(false)
	for node : Node3D in get_tree().get_nodes_in_group("minion_spawn"):
		minion_spawn_points.append(node.global_transform.origin)
	for node : Node3D in get_tree().get_nodes_in_group("pillar_points"):
		pillar_spawn_points.append(node.global_transform.origin)

func link_boss_health(boss_health : BossHealth) -> void:
	self.boss_health = boss_health
	boss_health.setup("Angler", initial_health)

func link_health(enemy : EnemyBase) -> void:
	enemy.link_boss(self)

func link_camera(camera : Camera3D) -> void:
	self.camera = camera

func link_spawner(enemy_spawner_ : EnemySpawner) -> void:
	enemy_spawner = enemy_spawner_


func check_state() -> void:
	if state_machine.current_state.is_complete:
		if state_machine.current_state == phase_change_state:
			print("starting phase ", current_phase)
			state_machine.set_state(phase_state_order[current_phase]) ## start in phase change state as intro
		else:
			state_machine.set_state(phase_change_state)
			current_phase += 1

func on_hit(attacker_hitbox : Hitbox) -> void:
	super(attacker_hitbox)
	boss_health.update_health(health_component.current_health)

func on_eye_died() -> void:
	var quarter: int = health_component.max_health / 4
	var next_quarter: int = ((health_component.current_health - 1) / quarter) * quarter
	var damage_taken: int = health_component.current_health - next_quarter
	sprite_manager.damage_flash()
	# next closest quarter of health 
	health_component.take_damage(damage_taken)
	hurt_box.on_valid_damaging_hit()
	state_machine.current_state.on_eye_died()
	boss_health.flash_health_bar()
	camera.camera_shake(2.0, 0.3)
	

func on_die() -> void:
	if is_dead:
		return
	super()
	enemy_spawner.kill_all_enemies() 

# 	super.on_die()
# 	boss_health.hide()
# func on_staggered() -> void:
	# pass
	# hurt_state.set_idle_duration(0.3)
	# state_machine.set_state(hurt_state)
