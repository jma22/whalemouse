class_name Player extends CharacterBody3D

@export var speed: float = 5.0
# @export var gravity: float = -9.8

@onready var sprite : Sprite3D = $Sprite3D
@onready var state_machine : StateMachine = $StateMachine
@onready var sprite_manager : SpriteManager = $SpriteManager
@onready var walk_state : WalkState = $StateMachine/WalkState
@onready var idle_state : IdleState = $StateMachine/IdleState

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
			state.set_player(self)

func on_hit(damage: int) -> void:
	print("Player hit for %d damage!" % damage)