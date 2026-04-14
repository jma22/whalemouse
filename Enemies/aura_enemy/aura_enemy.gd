extends EnemyBase
class_name AuraEnemy

@onready var enemy_idle_state : EnemyIdleState = $StateMachine/EnemyIdleState
@onready var hurt_state : EnemyHurtState = $StateMachine/EnemyHurtState
@onready var retreat_state : EnemyRetreatState = $StateMachine/EnemyRetreatState

@onready var peaceful_state : EnemyPeacefulState = $StateMachine/EnemyPeacefulState


var detection_range : float = 2.5

func setup(player: CharacterBody3D, map: NavigationRegion3D) -> void:
	initial_health = 1
	initial_state = peaceful_state
	super.setup(player, map)

func check_state() -> void:
	if not state_machine.current_state.is_complete and state_machine.current_state == hurt_state:
		return
	check_range()

func check_range() -> void:
	var distance_to_player : float = global_transform.origin.distance_to(player.global_transform.origin)
	if distance_to_player <= detection_range:
		state_machine.set_state(retreat_state)
	else:
		state_machine.set_state(peaceful_state)

func on_staggered() -> void:
	hurt_state.set_idle_duration(0.3)
	state_machine.set_state(hurt_state)
