class_name Player extends CharacterBody3D

@export var speed: float = 5.0
# @export var gravity: float = -9.8

@onready var state_machine : StateMachine = $StateMachine
@export var sprite_manager : SpriteManager
@export var health_component : HealthComponent
@onready var walk_state : WalkState = $StateMachine/WalkState
@onready var idle_state : IdleState = $StateMachine/IdleState
@onready var hurt_state : HurtState = $StateMachine/HurtState
@onready var roll_state : RollState = $StateMachine/RollState
@export var attack_state : AttackState

@export var hitstop : HitStop
var time_damage_manager : TimeDamageManager
#by default set the dash direction to prevent no velocity dashes
var last_direction : Vector2 = Vector2.LEFT
var invulnerable : bool = false

var initial_health : int = 60

# Input buffer — remembers the last action pressed within BUFFER_WINDOW seconds
const BUFFER_WINDOW : float = 0.2
var _buffered_action : StringName = &""
var _buffer_timer : float = 0.0

var status_effects : Array[StatusEffect] = []

func reset() -> void:
	# This can be called to reset the player's state, such as when restarting the game
	health_component.reset()
	sprite_manager.reset()	
	hitstop.reset()
	# state_machine.set_state(idle_state)

func setup(hud: HUD) -> void:
	# This is called from the main scene to set up references to other nodes
	health_component.setup(hud, initial_health)

func _ready() -> void:
	setup_states()
	state_machine.set_state(idle_state)

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
	move_and_slide()


func setup_states() -> void:
	for state : Node in state_machine.get_children():
		if state is State:
			state.set_entity(self)

func on_hit(damage: int) -> void:
	if invulnerable:
		return

	hitstop.start_hitstop(0.1)
	health_component.take_damage(damage)
	sprite_manager.damage_flash()
	if health_component.is_dead():
		on_die()
	else:
		state_machine.set_state(hurt_state)

func set_invulnerable(value: bool) -> void:
	invulnerable = value

func on_die() -> void:
	var tween = await sprite_manager.die()
	tween.finished.connect(func():
		SceneManager.switch_to(SceneManager.SceneEnum.GAME_OVER)
	)

func on_gain_time(amount : int) -> void:
	# handle gaining time pickup
	health_component.gain_health(amount)


func heal(amount: int) -> void:
	health_component.gain_health(amount)

func damage(amount: int) -> void:
	health_component.take_damage(amount)
	if health_component.is_dead():
		on_die()



func gain_status_effect(effect : StatusEffect) -> void:
	status_effects.append(effect)

func purge_effects() -> void:
	for effect in status_effects:
		if effect.time_remaining < 0:
			status_effects.erase(effect)
			return
	
func clear_effects() -> void:
	status_effects.clear()	
