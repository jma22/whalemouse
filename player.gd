class_name Player extends CharacterBody3D

@export var speed: float = 5.0
# @export var gravity: float = -9.8

@onready var state_machine : StateMachine = $StateMachine
@onready var sprite_manager : SpriteManager = $SpriteManager
@onready var health_component : HealthComponent = $HealthComponent
@onready var walk_state : WalkState = $StateMachine/WalkState
@onready var idle_state : IdleState = $StateMachine/IdleState
@onready var hurt_state : HurtState = $StateMachine/HurtState

func _ready() -> void:
	setup_states()
	state_machine.set_state(idle_state)

func _process(_delta: float) -> void:
	check_state()
	state_machine.current_state.deep_run(_delta)

func get_input() -> Vector2:
	var input_vector : Vector2 = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	return input_vector

func check_state() -> void:
	if state_machine.current_state is WalkState or state_machine.current_state is IdleState:
		neutral_state()
	elif state_machine.current_state is HurtState:
		if state_machine.current_state.is_complete:
			neutral_state()

			

func neutral_state() -> void:
	var input_vector : Vector2 = get_input()
	if input_vector.length() > 0:
		state_machine.set_state(walk_state)
	else:
		state_machine.set_state(idle_state)

func _physics_process(delta: float) -> void:
	state_machine.current_state.deep_fixed_run(delta)

func setup_states() -> void:
	for state : Node in state_machine.get_children():
		if state is State:
			state.set_entity(self)

func on_hit(damage: int) -> void:
	health_component.take_damage(damage)
	sprite_manager.damage_flash()
	state_machine.set_state(hurt_state)
