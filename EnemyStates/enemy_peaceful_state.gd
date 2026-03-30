extends State

class_name EnemyPeacefulState
@export var enemy_walk_state : EnemyWalkState
@export var enemy_idle_state : EnemyIdleState

@export var walk_radius : float = 1.0
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
			enemy_walk_state.set_target_position(get_random_walk_target_location())
			state_machine.set_state(enemy_walk_state)
	if get_child_state() == enemy_walk_state:
		if enemy_walk_state.is_complete:
			enemy_idle_state.set_idle_duration(get_idle_duration())
			state_machine.set_state(enemy_idle_state)

func get_idle_duration() -> float:
	return randf_range(idle_duration_min, idle_duration_max)

func get_random_walk_target_location() -> Vector3:
	var random_offset : Vector3 = Vector3(randf_range(-walk_radius, walk_radius), 0, randf_range(-walk_radius, walk_radius))
	## check if its in map 
	# var map : RID = entity.get_world_3d().navigation_map
	var map :AABB = entity.map.get_bounds()
	var target_point : Vector3 = entity.global_position + random_offset
	if not map.has_point(target_point):
		target_point.x = clamp(target_point.x, map.position.x, map.position.x + map.size.x)
		target_point.y = clamp(target_point.y, map.position.y, map.position.y + map.size.y)
		target_point.z = clamp(target_point.z, map.position.z, map.position.z + map.size.z)
	target_point.y = 0


	# var closest_point : Vector3= NavigationServer3D.map_get_closest_point(map, target_point)
	# print("Closest point on navigation map: ", closest_point)
	return target_point
