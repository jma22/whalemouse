extends EnemyBase
class_name Barnacle

@onready var enemy_idle_state : EnemyIdleState = $StateMachine/EnemyIdleState
@onready var hurt_state : EnemyHurtState = $StateMachine/EnemyHurtState
@onready var walk_state : EnemyWalkState = $StateMachine/EnemyWalkState
# @onready var retreat_state : EnemyRetreatState = $StateMachine/EnemyRetreatState

# @onready var peaceful_state : EnemyPeacefulState = $StateMachine/EnemyPeacefulState


var detection_range : float = 2.5

func setup(player: CharacterBody3D, map: NavigationRegion3D) -> void:
	enemy_idle_state.set_idle_duration(2.0)
	initial_state = enemy_idle_state
	super.setup(player, map)

func check_state() -> void:
	if state_machine.current_state.is_complete:
		if state_machine.current_state == hurt_state:
			walk_state.set_target_position(get_escape_position())
			state_machine.set_state(walk_state)
		elif state_machine.current_state == enemy_idle_state:
			state_machine.set_state(enemy_idle_state)
		elif state_machine.current_state == walk_state:
			state_machine.set_state(enemy_idle_state)


		
	# check_range()


func get_escape_position() -> Vector3:
	var direction_away : Vector3 = (global_transform.origin - player.global_transform.origin).normalized()
	var angle_offset : float = randf_range(-PI / 3.0, PI / 3.0)  # up to 60 degrees off center
	var rotated_direction : Vector3 = Vector3(
		direction_away.x * cos(angle_offset) - direction_away.z * sin(angle_offset),
		direction_away.y,
		direction_away.x * sin(angle_offset) + direction_away.z * cos(angle_offset)
	)
	var target_location : Vector3= global_transform.origin + rotated_direction * randf_range(2.0, 2.5)
	# target_location = get_floor().clamp_position(target_location, 0.5)
	target_location = get_floor().mirror_position(target_location)
	return target_location

# func check_range() -> void:
# 	var distance_to_player : float = global_transform.origin.distance_to(player.global_transform.origin)
# 	if distance_to_player <= detection_range:
# 		state_machine.set_state(retreat_state)
# 	else:
# 		state_machine.set_state(peaceful_state)

func on_staggered() -> void:
	hurt_state.set_idle_duration(0.2)
	state_machine.set_state(hurt_state)
