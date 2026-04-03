extends CharacterBody3D
class_name Enemy 

@export var map : NavigationRegion3D
@export var player : CharacterBody3D
@export var xp_spawner_scene : PackedScene
@export var hitstop : HitStop

@onready var state_machine : StateMachine = $StateMachine
@onready var sprite_manager : SpriteManager = $SpriteManager
@onready var health_component : HealthComponent = $HealthComponent
@onready var hitbox : Node = $Hitbox
# @onready var walk_state : WalkState = $StateMachine/WalkState
@onready var enemy_idle_state : EnemyIdleState = $StateMachine/EnemyIdleState
@onready var hurt_state : EnemyHurtState = $StateMachine/EnemyHurtState
@onready var retreat_state : EnemyRetreatState = $StateMachine/EnemyRetreatState
@onready var approach_state : EnemyPursuitState = $StateMachine/EnemyPursuitState
@onready var attack_state : EnemyAttackState = $StateMachine/EnemyAttackState
@onready var peaceful_state : EnemyPeacefulState = $StateMachine/EnemyPeacefulState
@onready var charge_state : EnemyChargeState = $StateMachine/EnemyChargeState
@onready var knockback_component : KnockbackComponent = $KnockbackComponent

var pursuit_range : float = 3.0
var attack_range : float = 1.5
var initial_health : int = 2
var is_dead : bool = false
var is_invulnerable : bool = false

func setup(player : CharacterBody3D, map : NavigationRegion3D) -> void:
	self.player = player
	self.map = map
	health_component.setup(null, ceil(initial_health * GlobalStats.get_enemy_health_multiplier()))


func _ready() -> void:
	setup_states()
	state_machine.set_state(enemy_idle_state)

func _process(_delta: float) -> void:
	if is_dead or hitstop.is_in_hitstop:
		return
	check_state()
	state_machine.current_state.deep_run(_delta)
	# print(state_machine.get_current_all_states())

func check_state() -> void:
	if state_machine.current_state.is_complete:
		if state_machine.current_state == charge_state:
			state_machine.set_state(attack_state)
		elif state_machine.current_state == attack_state:
			enemy_idle_state.set_idle_duration(randf() * 1.0 + 0.5)
			state_machine.set_state(enemy_idle_state)
		elif state_machine.current_state == enemy_idle_state:
			check_range()
		elif state_machine.current_state == retreat_state:
			check_range()
		elif state_machine.current_state == approach_state:
			check_range()
		elif state_machine.current_state == hurt_state:
			check_range()
	else:
		if state_machine.current_state == peaceful_state:	
			check_range()
		# elif state_machine.current_state == approach_state:
		# 	state_machine.set_state(enemy_idle_state)


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

func _physics_process(delta: float) -> void:
	if is_dead or hitstop.is_in_hitstop:
		return
	state_machine.current_state.deep_fixed_run(delta)
	knockback_component.handle_knockback()
	move_and_slide()



func setup_states() -> void:
	for state : Node in state_machine.get_children():
		if state is State:
			state.set_entity(self)

func on_hit(damage: int) -> void:
	if is_dead or is_invulnerable:
		return
	sprite_manager.damage_flash()
	health_component.take_damage(damage)
	on_staggered()
	hitstop.start_hitstop(0.2)

	# if state_machine.current_state.has_method("on_hit"):
	# 	state_machine.current_state.on_hit(damage)

	

	if health_component.is_dead():
		on_die()
		var knockback_direction : Vector3 = (global_transform.origin - player.global_transform.origin).normalized()
		knockback_component.receive_knockback(knockback_direction, 0.4*damage)
		return

	var knockback_direction : Vector3 = (global_transform.origin - player.global_transform.origin).normalized()
	knockback_component.receive_knockback(knockback_direction, damage)

func on_die() -> void:
	if is_dead:
		return
	is_dead = true
	var tween = await sprite_manager.die()
	GlobalStats.add_kill()

	await tween.finished
	if xp_spawner_scene:
		var xp_spawner_instance = xp_spawner_scene.instantiate()
		get_parent().add_child(xp_spawner_instance)
		xp_spawner_instance.global_transform.origin = global_transform.origin
		xp_spawner_instance.setup(GlobalStats.get_enemy_xp_drop(), player)
	process_mode = Node.PROCESS_MODE_DISABLED


func on_staggered() -> void:
	hurt_state.set_idle_duration(0.3)
	state_machine.set_state(hurt_state)


func set_invulnerable(value: bool) -> void:
	is_invulnerable = value
