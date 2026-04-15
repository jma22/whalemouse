extends State

class_name EnemyPeacefulState
@export var enemy_walk_state : EnemyWalkState
@export var enemy_idle_state : EnemyIdleState

@export var init_walk_radius : float = 1.0
@export var idle_duration_min : float = 0.5
@export var idle_duration_max : float = 1.5

func enter() -> void:
	enemy_idle_state.set_idle_duration(get_idle_duration())
	state_machine.set_state(enemy_idle_state)

func run(_delta: float) -> void:
	check_state()

func check_state() -> void:
	if get_child_state() == enemy_idle_state:
		if enemy_idle_state.is_complete:
			var target_position : Vector3 = get_random_walk_target_location()
			enemy_walk_state.set_target_position(target_position)
			var facing_left :bool = target_position.x < entity.global_transform.origin.x
			entity.set_sprite_flip(facing_left)
			state_machine.set_state(enemy_walk_state)
	if get_child_state() == enemy_walk_state:
		if enemy_walk_state.is_complete:
			enemy_idle_state.set_idle_duration(get_idle_duration())
			state_machine.set_state(enemy_idle_state)

func get_idle_duration() -> float:
	return randf_range(idle_duration_min, idle_duration_max) / GlobalStats.get_enemy_speed_multiplier() ## faster enemies have shorter idle times

func get_random_walk_target_location() -> Vector3:
	var max_tries : int = 4
	var walk_radius : float = init_walk_radius * GlobalStats.get_enemy_speed_multiplier()
	for i in range(max_tries):
		var random_offset : Vector3 = Vector3(randf_range(-walk_radius, walk_radius), 0, randf_range(-walk_radius, walk_radius))
		var target_point : Vector3 = entity.global_position + random_offset
		if entity.get_floor().check_in_bounds(target_point, 0.1):
			return target_point

	# If all else fails, just stay in place
	return entity.global_position
