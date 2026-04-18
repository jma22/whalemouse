extends State

class_name EnemyPursuitState
@export var enemy_walk_state : EnemyWalkState
@export var enemy_idle_state : EnemyIdleState

func enter() -> void:
	enemy_idle_state.set_idle_duration(get_idle_duration())
	state_machine.set_state(enemy_idle_state)

func run(_delta: float) -> void:
	check_state()


func check_state() -> void:
	print("Current child state: ", get_child_state())
	if get_child_state() == enemy_idle_state:
		if enemy_idle_state.is_complete:
			var target_position : Vector3 = get_walk_toward_player()
			enemy_walk_state.set_target_position(target_position)
			var facing_left : bool =  target_position.x < entity.global_transform.origin.x
			entity.set_sprite_flip(facing_left)
			state_machine.set_state(enemy_walk_state)
	if get_child_state() == enemy_walk_state:
		if enemy_walk_state.is_complete:
			enemy_idle_state.set_idle_duration(get_idle_duration())
			state_machine.set_state(enemy_idle_state)
			is_complete = true

func get_idle_duration() -> float:
	return 0.4 / GlobalStats.get_enemy_speed_multiplier() ## faster enemies have shorter idle times

func get_walk_toward_player() -> Vector3:
	var direction : Vector3 = (entity.player.global_transform.origin - entity.global_transform.origin).normalized()
	var pick_direction : Vector3 = sample_cardinal_direction(direction)
	var distance : float = sample_random_distance()
	var target_point : Vector3 = entity.global_transform.origin + pick_direction * distance

	target_point = entity.get_floor().clamp_position(target_point, 0.1)
	target_point.y = 0
	return target_point

func sample_random_distance() -> float:
	return randf_range(0.2, 0.8)


func sample_cardinal_direction(direction: Vector3) -> Vector3:
	# 33% closest, 20% second clsest, 20% third closest, 27% random from remaining
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
	var index : int = cardinal_directions.find(closest_direction)
	var pick : float = randf()
	if pick < 0.5:
		return closest_direction
	elif pick < 0.5 + 0.2:
		var second_index : int = (index + 1) % cardinal_directions.size()
		return cardinal_directions[second_index]
	elif pick < 0.5 + 0.2 + 0.2:
		var third_index : int = (index - 1 + cardinal_directions.size()) % cardinal_directions.size()
		return cardinal_directions[third_index]
	else:
		var remaining_indices : Array[int] = []
		for i in range(cardinal_directions.size()):
			if i != index and i != (index + 1) % cardinal_directions.size() and i != (index - 1 + cardinal_directions.size()) % cardinal_directions.size():
				remaining_indices.append(i)
		var random_index : int = remaining_indices[randi() % remaining_indices.size()]
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
