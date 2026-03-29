class_name Enemy extends CharacterBody3D

@export var map : NavigationRegion3D
@export var player : CharacterBody3D

@onready var state_machine : StateMachine = $StateMachine
@onready var sprite_manager : SpriteManager = $SpriteManager
@onready var health_component : HealthComponent = $HealthComponent
@onready var hitbox : Node = $Hitbox
# @onready var walk_state : WalkState = $StateMachine/WalkState
# @onready var idle_state : IdleState = $StateMachine/IdleState
# @onready var hurt_state : HurtState = $StateMachine/HurtState
# @onready var retreat_state : RetreatState = $StateMachine/RetreatState
@onready var approach_state : EnemyPursuitState = $StateMachine/EnemyPursuitState
@onready var attack_state : EnemyAttackState = $StateMachine/EnemyAttackState
@onready var peaceful_state : EnemyPeacefulState = $StateMachine/EnemyPeacefulState
@onready var charge_state : EnemyChargeState = $StateMachine/EnemyChargeState

func _ready() -> void:
	setup_states()
	state_machine.set_state(charge_state)

func _process(_delta: float) -> void:
	check_state()
	state_machine.current_state.deep_run(_delta)
	# print(state_machine.get_current_all_states())

func check_state() -> void:
	if state_machine.current_state.is_complete:
		if state_machine.current_state == charge_state:
			state_machine.set_state(attack_state)
		elif state_machine.current_state == attack_state:
			state_machine.set_state(charge_state)



func _physics_process(delta: float) -> void:
	state_machine.current_state.deep_fixed_run(delta)

func setup_states() -> void:
	for state : Node in state_machine.get_children():
		if state is State:
			state.set_entity(self)

func on_hit(damage: int) -> void:
	health_component.take_damage(damage)
	# state_machine.set_state(hurt_state)
