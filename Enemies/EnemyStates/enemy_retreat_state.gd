extends State

class_name EnemyRetreatState
@export var enemy_walk_state : EnemyWalkState
@export var enemy_idle_state : EnemyIdleState

func enter() -> void:
	enemy_idle_state.set_idle_duration(get_idle_duration())
	state_machine.set_state(enemy_idle_state)

func run(_delta: float) -> void:
	check_state()


func check_state() -> void:
	if get_child_state() == enemy_idle_state:
		if enemy_idle_state.is_complete:
			var target_position : Vector3 = get_walk_away_player()

			enemy_walk_state.set_target_position(target_position)
			var facing_left = target_position.x < entity.global_transform.origin.x
			entity.set_sprite_flip(facing_left)
			state_machine.set_state(enemy_walk_state)
	if get_child_state() == enemy_walk_state:
		if enemy_walk_state.is_complete:
			enemy_idle_state.set_idle_duration(get_idle_duration())
			state_machine.set_state(enemy_idle_state)
			is_complete = true

func get_idle_duration() -> float:
	return 0.2 / GlobalStats.get_enemy_speed_multiplier()

func get_walk_away_player() -> Vector3:
	var direction : Vector3 = (entity.global_transform.origin - entity.player.global_transform.origin).normalized()
	var pick_direction : Vector3 = sample_cardinal_direction(direction)
	var distance : float = sample_random_distance()
	var target_point : Vector3 = entity.global_transform.origin + pick_direction * distance

	var map : AABB = entity.map.get_bounds()
	if not map.has_point(target_point):
		print("flipping")
		if target_point.x < map.position.x:
			# mirror across the edge of the map to ensure it's always a valid point
			target_point.x = map.position.x + (map.position.x - target_point.x) *2
		elif target_point.x > map.position.x + map.size.x:
			target_point.x = map.position.x + map.size.x - (target_point.x - (map.position.x + map.size.x)) *2
		if target_point.z < map.position.z:
			target_point.z = map.position.z + (map.position.z - target_point.z)*2
		elif target_point.z > map.position.z + map.size.z:
			target_point.z = map.position.z + map.size.z - (target_point.z - (map.position.z + map.size.z))*2
	target_point.y = 0
	return target_point

func sample_random_distance() -> float:
	return randf_range(0.5, 0.8) * GlobalStats.get_enemy_speed_multiplier()


func sample_cardinal_direction(direction: Vector3) -> Vector3:
	# 70% closest, 20% second closest, 10% third closest, 0% random from remaining
	var cardinal_directions : Array[Vector3] = [
		Vector3(1, 0, 0),
		Vector3(-1, 0, 0),
		Vector3(0, 0, 1),
		Vector3(0, 0, -1),
		Vector3(1, 0, 1).normalized(),
		Vector3(1, 0, -1).normalized(),
		Vector3(-1, 0, 1).normalized(),
		Vector3(-1, 0, -1).normalized()
	]
	var closest_direction : Vector3 = get_closest_cardinal_direction(direction)
	var index = cardinal_directions.find(closest_direction)
	var pick = randf()
	if pick < 0.5:
		return closest_direction
	elif pick < 0.5 + 0.1:
		var second_index = (index + 1) % cardinal_directions.size()
		return cardinal_directions[second_index]
	elif pick < 0.5 + 0.1 + 0.1:
		var third_index = (index - 1 + cardinal_directions.size()) % cardinal_directions.size()
		return cardinal_directions[third_index]
	else:
		var remaining_indices : Array[int] = []
		for i in range(cardinal_directions.size()):
			if i != index and i != (index + 1) % cardinal_directions.size() and i != (index - 1 + cardinal_directions.size()) % cardinal_directions.size():
				remaining_indices.append(i)
		var random_index = remaining_indices[randi() % remaining_indices.size()]
		return cardinal_directions[random_index]

func get_closest_cardinal_direction(direction: Vector3) -> Vector3:
	var cardinal_directions : Array[Vector3] = [
		Vector3(1, 0, 0),
		Vector3(-1, 0, 0),
		Vector3(0, 0, 1),
		Vector3(0, 0, -1),
		Vector3(1, 0, 1).normalized(),
		Vector3(1, 0, -1).normalized(),
		Vector3(-1, 0, 1).normalized(),
		Vector3(-1, 0, -1).normalized()
	]
	var closest_direction : Vector3 = cardinal_directions[0]
	var max_dot : float = direction.dot(closest_direction)
	for dir in cardinal_directions:
		var dot : float = direction.dot(dir)
		if dot > max_dot:
			max_dot = dot
			closest_direction = dir
	return closest_direction
