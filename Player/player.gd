class_name Player extends CharacterBody3D

@export var speed: float = 5.0
# @export var gravity: float = -9.8

@onready var state_machine : StateMachine = $StateMachine

@onready var walk_state : WalkState = $StateMachine/WalkState
@onready var idle_state : IdleState = $StateMachine/IdleState
@onready var hurt_state : HurtState = $StateMachine/HurtState
@onready var roll_state : RollState = $StateMachine/RollState
@onready var dead_state : DeadState = $StateMachine/DeadState
@onready var grapple_state : GrappleState = $StateMachine/GrappleState
@export var attack_state : AttackState
@export var thorn_hitbox : Hitbox

@export var core_components : CoreComponents

@onready var health_component : HealthComponent = core_components.health_component
@onready var invulnerable_component : InvulnerableComponent = core_components.invulnerable_component
@onready var knockback_component : KnockbackComponent = core_components.knockback_component
@onready var hurt_box : HurtBox = core_components.hurt_box
@onready var sprite_manager : SpriteManager = core_components.sprite_manager
@onready var hitstop : HitStop = core_components.hitstop
@onready var status_effect_manager : StatusEffectManager = core_components.status_effect_manager

@onready var dash_component : DashComponent = $DashComponent 

@export var time_damage_manager : TimeDamageManager
var hud_ref : HUD
var map_ref : MapManagerBase
#by default set the dash direction to prevent no velocity dashes
var last_direction : Vector2 = Vector2.LEFT

var initial_health : int = StatCalculator.get_player_max_health()
var disable_input : bool = false
# Input buffer — remembers the last action pressed within BUFFER_WINDOW seconds
const BUFFER_WINDOW : float = 0.2
var _buffered_action : StringName = &""
var _buffer_timer : float = 0.0

var status_effects : Array[PlayerStatusEffect] = []
var camera_ref : Camera3D

func reset() -> void:
	core_components.reset()
	status_effects.clear()
	disable_input = false

func setup(hud: HUD, camera : Camera3D) -> void:
	# This is called from the main scene to set up references to other nodes
	core_components.setup(self)
	core_components.link_hud(hud)
	hud_ref = hud
	camera_ref = camera
	setup_states()
	state_machine.set_state(idle_state)

func enter_map(map : MapManagerBase) -> void:
	map_ref = map

# func _ready() -> void:
# 	setup_states()
# 	state_machine.set_state(idle_state)

func _process(_delta: float) -> void:
	_tick_input_buffer(_delta)
	if hitstop.is_in_hitstop or disable_input:
		return
	if state_machine.current_state:
		check_state()
		state_machine.current_state.deep_run(_delta)

func get_input() -> Vector2:
	var input_vector : Vector2 = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	return input_vector

func _tick_input_buffer(delta: float) -> void:
	if disable_input:
		return
	# Record new presses into the buffer
	if StatCalculator.has_dash() and Input.is_action_just_pressed("dash"):
		_buffered_action = &"dash"
		_buffer_timer = BUFFER_WINDOW
	elif Input.is_action_just_pressed("atk"):
		_buffered_action = &"atk"
		_buffer_timer = BUFFER_WINDOW
	# Count down and expire
	if _buffer_timer > 0.0:
		_buffer_timer -= delta
		if _buffer_timer <= 0.0:
			_buffered_action = &""

func _consume_buffered(action: StringName) -> bool:
	if _buffered_action == action:
		_buffered_action = &""
		_buffer_timer = 0.0
		return true
	return false

func check_state() -> void:
	if state_machine.current_state.is_complete:
		# if state_machine.current_state is HurtState or state_machine.current_state is RollState:
		neutral_state()
	else:
		if state_machine.current_state is WalkState or state_machine.current_state is IdleState:
			neutral_state()


func neutral_state() -> void:
	var input_vector : Vector2 = get_input()
	var did_dash : bool = _consume_buffered(&"dash")
	var did_attack : bool = _consume_buffered(&"atk")
	if input_vector.length() > 0:
		last_direction = input_vector
	if did_dash and dash_component.can_dash():
		roll_state.set_direction(last_direction)
		state_machine.set_state(roll_state)
		dash_component.set_dash_cooldown()
		return

	if did_attack:
		attack_state.set_direction(last_direction)
		state_machine.set_state(attack_state)
		return

	if input_vector.length() > 0:
		state_machine.set_state(walk_state)
	else:
		state_machine.set_state(idle_state)

func _physics_process(delta: float) -> void:
	if hitstop.is_in_hitstop or not state_machine.current_state:
		return
	state_machine.current_state.deep_fixed_run(delta)
	knockback_component.handle_knockback()
	move_and_slide()


func setup_states() -> void:
	for state : Node in state_machine.get_children():
		if state is State:
			state.set_entity(self)

func on_hit(info: DamageInfo) -> void:
	var hitbox : Hitbox = info.hitbox
	DebugLog.dbg("Combat", "Player hit by %s [%s]" % [DebugLog.entity_name(hitbox), DamageInfo.DamageType.keys()[info.damage_type]])
	if invulnerable_component.is_currently_invulnerable():
		return
	hitbox.hitbox_on_hit() ##HITSTOP
	hitstop.start_hitstop(0.1)
	if hitbox.behavior:
		hitbox.behavior.modify_outgoing_damage(info, self)
	status_effect_manager.modify_incoming_damage(info)
	var damage_taken : int = info.amount
	if damage_taken == 0:
		return

	var reduced_by : int = StatCalculator.get_damage_reduced_by()
	if reduced_by > 0:
		DebugLog.dbg("Combat", "damage_reduced_by=%s: %s→%s" % [reduced_by, damage_taken, max(0, damage_taken - reduced_by)])
	damage_taken = max(0, damage_taken - reduced_by)
	if StatCalculator.has_death_dance():
		damage_taken = min(damage_taken, 1)
		gain_status_effect(HasteEffect.make(2.0), self)
		DebugLog.dbg("Combat", "death_dance → dmg capped to 1, gained Haste(2.0s)")
	if map_ref is BossMapManager:
		if StatCalculator.get_decay_duration_on_hit() > 0:
			for i in range(StatCalculator.get_decay_duration_on_hit()):
				gain_status_effect(HasteEffect.make(2.0), self)
			DebugLog.dbg("Combat", "decay_duration_on_hit → gained Haste(%.1fs)" % StatCalculator.get_decay_duration_on_hit())
	var hp_before : int = health_component.current_health
	health_component.take_damage(damage_taken)
	DebugLog.dbg("Combat", "Player took %s dmg | hp: %s→%s%s" % [
		damage_taken, hp_before, health_component.current_health,
		" | DEAD" if health_component.is_dead() else ""
	])

	if StatCalculator.get_decay_on_damaged() > 0:
		for i in range(StatCalculator.get_decay_on_damaged()):
			gain_status_effect(HasteEffect.make(2.0), self)
		DebugLog.dbg("Combat", "decay_on_damaged → gained Haste(%.1fs)" % StatCalculator.get_decay_on_damaged())

	# if hitbox.effect_on_hit:
	# 	gain_status_effect(hitbox.effect_on_hit, hitbox)
	
	status_effect_manager.notify_hit_consumed(info)

	sprite_manager.damage_flash()
	hud_ref.flash_hurt_vignette()
	hurt_box.on_valid_damaging_hit()
	camera_ref.camera_shake(0.2, 0.25)

	# if StatCalculator.has_thorns():
	# 	thorn_hitbox.set_damage(StatCalculator.get_thorns_damage())
	# 	if info.source and info.source.has_method("on_hit"):
	# 		info.source.on_hit(thorn_hitbox.build_damage_info(info.source))


	var knockback_direction : Vector3 = (global_transform.origin - info.owner_entity.global_transform.origin).normalized()
	if health_component.is_dead():
		# status_effect_manager.notify_owner_killed(info.get_source())
		on_die()
		knockback_component.receive_knockback(knockback_direction, 0.4*damage_taken)
		return
	else:
		knockback_component.receive_knockback(knockback_direction, damage_taken)
		state_machine.set_state(hurt_state)

	# if health_component.is_dead():
	# 	on_die()
	# 	knockback_component.receive_knockback(knockback_direction, 0.4*damage_taken)
	# 	return

	# knockback_component.receive_knockback(knockback_direction, damage_taken)

func set_invulnerable(value: bool, duration: float = 0.0) -> void:
	invulnerable_component.set_invulnerable(value, duration)

func on_die() -> void:
	state_machine.set_state(dead_state)

	
func get_floor() -> FloorNav:
	return map_ref.floor


## pickup / actions
func on_gain_time(amount : int) -> void:
	# handle gaining time pickup
	health_component.gain_health(amount)
	if StatCalculator.get_flow_stacks_per_pickup() > 0:
		gain_status_effect(FlowEffect.make(StatCalculator.get_flow_stacks_per_pickup()), self)

func heal(amount: int) -> void:
	health_component.gain_health(amount)

func damage(amount: int) -> void:
	health_component.take_damage(amount)
	if health_component.is_dead():
		on_die()

func clear_effects() -> void:
	status_effect_manager.clear_effects()

func gain_status_effect(effect : PlayerStatusEffect, source : Object) -> void:
	if effect.get_affects_enemy():
		return
	status_effect_manager.gain_status_effect(effect, source)

func lose_status_effect(effect : PlayerStatusEffect, source : Object) -> void:
	status_effect_manager.lose_status_effect(effect, source)

func get_initial_health() -> int:
	var override : Variant = Config.get_override("starting_health")
	DebugLog.dbg_from(self,"get_initial_health override=%s, max_health=%s" % [override, StatCalculator.get_player_max_health()])
	return override if override != null else StatCalculator.get_player_max_health()

func set_pause(value: bool) -> void:
	process_mode = Node.PROCESS_MODE_DISABLED if value else Node.PROCESS_MODE_INHERIT
	time_damage_manager.set_pause(value)

func get_projectile_flat() -> int:
	# return StatCalculator.get_projectile_flat()
	return 0

	
