@abstract
extends CharacterBody3D
class_name EnemyBase

@export var floor_ : FloorNav
@export var player : CharacterBody3D
var xp_spawner_scene : PackedScene = load("res://Collectibles/xp_spawner.tscn")

@onready var state_machine : StateMachine = $StateMachine

# @onready var hitbox : Node = $Hitbox
# @onready var walk_state : WalkState = $StateMachine/WalkState
# @onready var enemy_idle_state : EnemyIdleState = $StateMachine/EnemyIdleState
# @onready var hurt_state : EnemyHurtState = $StateMachine/EnemyHurtState
# @onready var retreat_state : EnemyRetreatState = $StateMachine/EnemyRetreatState
# @onready var approach_state : EnemyPursuitState = $StateMachine/EnemyPursuitState
# @onready var attack_state : EnemyAttackState = $StateMachine/EnemyAttackState
# @onready var peaceful_state : EnemyPeacefulState = $StateMachine/EnemyPeacefulState
# @onready var charge_state : EnemyChargeState = $StateMachine/EnemyChargeState

@export var initial_health : int = 1
@export var initial_state : State
@export var xp_drop_amount : int = 1
@export var ebb_drop_amount : int = 0
@export var core_components : CoreComponents

@onready var health_component : HealthComponent = core_components.health_component
@onready var invulnerable_component : InvulnerableComponent = core_components.invulnerable_component
@onready var knockback_component : KnockbackComponent = core_components.knockback_component
@onready var hurt_box : HurtBox = core_components.hurt_box
@onready var sprite_manager : SpriteManager = core_components.sprite_manager
@onready var hitstop : HitStop = core_components.hitstop
@onready var bounce_component : BounceComponent = core_components.bounce_component
@onready var status_effect_manager : StatusEffectManager = core_components.status_effect_manager
@onready var shield_component : ShieldComponent = core_components.shield_component

var is_dead : bool = false
var setup_complete : bool = false
@export var skip_physics : bool = false


# var facing_left : bool = false
func setup(player_ : CharacterBody3D, floor_ : NavigationRegion3D) -> void:
	self.player = player_
	self.floor_ = floor_
	core_components.setup(self)
	setup_states()
	state_machine.set_state(initial_state)
	setup_complete = true
	invulnerable_component.set_invulnerable(true, 0.2)


# func _ready() -> void:
	
func _process(_delta: float) -> void:
	if not setup_complete:
		return
	if is_dead or hitstop.is_in_hitstop:
		return
	if state_machine.current_state:
		check_state()
		state_machine.current_state.deep_run(_delta)
	# if facing_left:
	# 	sprite_manager.set_flip(true)
	# else:
	# 	sprite_manager.set_flip(false)

func _physics_process(delta: float) -> void:
	if not setup_complete or skip_physics:
		return
	if is_dead or hitstop.is_in_hitstop:
		return
	
	if state_machine.current_state:
		state_machine.current_state.deep_fixed_run(delta)
	knockback_component.handle_knockback()
	bounce_component.handle_bounce()
	move_and_slide()
	bounce_component.clamp_and_bounce()


@abstract
func check_state() -> void

func setup_states() -> void:
	for state : Node in state_machine.find_children("*", "State", true, false):
		if state is State:
			state.set_entity(self)

func on_hit(info: DamageInfo) -> void:
	if is_dead or invulnerable_component.is_currently_invulnerable():
		return
	sprite_manager.damage_flash()
	var hitbox : Hitbox = info.hitbox
	if hitbox.behavior:
		hitbox.behavior.modify_outgoing_damage(info, self)
	status_effect_manager.modify_incoming_damage(info)
	var damage_taken : int = info.amount
	hitbox.hitbox_on_hit() # hitstop
	hitstop.start_hitstop(0.2)
	if damage_taken == 0:
		return

	health_component.take_damage(damage_taken)

	status_effect_manager.notify_hit_consumed(info) ## consume first
	if hitbox.effect_on_hit:
		gain_status_effect(hitbox.effect_on_hit, hitbox)
	hurt_box.on_valid_damaging_hit()
	if hitbox.behavior:
		hitbox.behavior.on_hit_landed(info, self)

	on_staggered()

	var knockback_direction : Vector3 = Vector3.ZERO
	if info.owner_entity != null:
		knockback_direction = (global_transform.origin - info.owner_entity.global_transform.origin).normalized()
	knockback_component.receive_knockback(knockback_direction, damage_taken)


	if health_component.is_dead():
		status_effect_manager.notify_owner_killed(info.source)
		if hitbox.behavior:
			hitbox.behavior.on_kill(info, self)
		on_die()
		knockback_component.receive_knockback(knockback_direction, -0.6*damage_taken)
		return



func on_die() -> void:
	if is_dead:
		return
	is_dead = true
	var tween : Tween = await sprite_manager.die()
	GlobalStats.add_kill()
	


	await tween.finished
	if status_effect_manager.has_status_effect("cursed"):
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	if xp_spawner_scene:
		var xp_spawner_instance : Node = xp_spawner_scene.instantiate()
		get_parent().add_child(xp_spawner_instance)
		xp_spawner_instance.global_transform.origin = global_transform.origin
		xp_spawner_instance.global_transform.origin.y = 0.0
		if randf() < 0.33:
			xp_spawner_instance.setup_outwards(xp_drop_amount + StatCalculator.get_bonus_enemy_xp_drop(), player, CollectibleSpawner.OrbType.TIME, get_floor())
		else:
			xp_spawner_instance.setup_outwards(xp_drop_amount, player, CollectibleSpawner.OrbType.TIME, get_floor())

		if randf() < 0.5:
			xp_spawner_instance.setup_outwards(ebb_drop_amount, player, CollectibleSpawner.OrbType.EBB, get_floor())
		else:
			xp_spawner_instance.setup_outwards(ebb_drop_amount + StatCalculator.get_ebb_drop(), player, CollectibleSpawner.OrbType.EBB, get_floor())
			
	process_mode = Node.PROCESS_MODE_DISABLED	

func on_staggered() -> void:
	pass

func set_invulnerable(value: bool, duration: float = 0.0) -> void:
	invulnerable_component.set_invulnerable(value, duration)

func set_sprite_flip(left: bool) -> void:
	sprite_manager.set_flip(left)

func get_floor() -> NavigationRegion3D:
	return floor_

func get_speed_multiplier() -> float:
	return StatCalculator.get_enemy_speed_multiplier() * status_effect_manager.get_speed_multiplier()

func get_attack_speed_multiplier() -> float:
	return StatCalculator.get_enemy_attack_speed_multiplier() * status_effect_manager.get_attack_speed_multiplier()

func get_projectile_flat() -> int:
	return StatCalculator.get_enemy_projectile_flat() + status_effect_manager.get_projectile_flat()

func clear_effects() -> void:
	status_effect_manager.clear_effects()

func gain_status_effect(effect : EnemyStatusEffect, source : Object) -> void:
	if not effect.get_affects_enemy():
		return

	status_effect_manager.gain_status_effect(effect, source)

func lose_status_effect(effect : EnemyStatusEffect, source : Object) -> void:
	status_effect_manager.lose_status_effect(effect, source)

