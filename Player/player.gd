class_name Player extends CharacterBody3D

@export var speed: float = 5.0
# @export var gravity: float = -9.8

@onready var state_machine : StateMachine = $StateMachine

@onready var walk_state : WalkState = $StateMachine/WalkState
@onready var idle_state : IdleState = $StateMachine/IdleState
@onready var hurt_state : HurtState = $StateMachine/HurtState
@onready var roll_state : RollState = $StateMachine/RollState
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
var time_damage_manager : TimeDamageManager
var hud_ref : HUD
var map_ref : MapManagerBase
#by default set the dash direction to prevent no velocity dashes
var last_direction : Vector2 = Vector2.LEFT

var initial_health : int = 60

# Input buffer — remembers the last action pressed within BUFFER_WINDOW seconds
const BUFFER_WINDOW : float = 0.2
var _buffered_action : StringName = &""
var _buffer_timer : float = 0.0

var status_effects : Array[StatusEffect] = []
var camera_ref : Camera3D

func reset() -> void:
	core_components.reset()
	status_effects.clear()

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
	if hitstop.is_in_hitstop:
		return
	check_state()
	state_machine.current_state.deep_run(_delta)

func get_input() -> Vector2:
	var input_vector : Vector2 = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	return input_vector

func _tick_input_buffer(delta: float) -> void:
	# Record new presses into the buffer
	if GlobalStats.has_dash() and Input.is_action_just_pressed("dash"):
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
	if did_dash:
		roll_state.set_direction(last_direction)
		state_machine.set_state(roll_state)
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
	if hitstop.is_in_hitstop:
		return
	state_machine.current_state.deep_fixed_run(delta)
	knockback_component.handle_knockback()
	move_and_slide()


func setup_states() -> void:
	for state : Node in state_machine.get_children():
		if state is State:
			state.set_entity(self)

func on_hit(attacker_hitbox: Hitbox) -> void:
	print("Player hit by ", attacker_hitbox.name)
	if invulnerable_component.is_currently_invulnerable():
		return
	attacker_hitbox.hitbox_on_hit() ##HITSTOP
	hitstop.start_hitstop(0.1)
	var damage_taken : int = attacker_hitbox.get_damage()
	if damage_taken == 0:
		return
	damage_taken = max(0, damage_taken - GlobalStats.get_damage_reduced_by())
	if map_ref is BossMapManager:
		if GlobalStats.get_curse_duration_on_hit() > 0:
			gain_status_effect(StatusEffect.create("haste", GlobalStats.get_curse_duration_on_hit()), self)
	health_component.take_damage(damage_taken)
	sprite_manager.damage_flash()
	hud_ref.flash_hurt_vignette()
	hurt_box.on_valid_damaging_hit()

	if GlobalStats.has_thorns():
		thorn_hitbox.set_damage(GlobalStats.get_thorns_damage())
		if attacker_hitbox.owner_entity and attacker_hitbox.owner_entity.has_method("on_hit"):
			attacker_hitbox.owner_entity.on_hit(thorn_hitbox)
	

	var knockback_direction : Vector3 = (global_transform.origin - attacker_hitbox.owner_entity.global_transform.origin).normalized()
	if health_component.is_dead():
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
	var tween : Tween = await sprite_manager.die()
	tween.finished.connect(func() -> void:
		SceneManager.switch_to(SceneManager.SceneEnum.GAME_OVER)
	)
func get_floor() -> FloorNav:
	return map_ref.floor


## pickup / actions
func on_gain_time(amount : int) -> void:
	# handle gaining time pickup
	health_component.gain_health(amount)

func heal(amount: int) -> void:
	health_component.gain_health(amount)

func damage(amount: int) -> void:
	health_component.take_damage(amount)
	if health_component.is_dead():
		on_die()

func clear_effects() -> void:
	status_effect_manager.clear_effects()

func gain_status_effect(effect : StatusEffect, source : Object) -> void:
	status_effect_manager.gain_status_effect(effect, source)

func lose_status_effect(effect : StatusEffect, source : Object) -> void:
	status_effect_manager.lose_status_effect(effect, source)
