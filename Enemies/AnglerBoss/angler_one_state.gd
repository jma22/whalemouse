extends State

# @export var audio_player : AudioStreamPlayer
# var spike_scene : PackedScene = load("res://Enemies/Projectiles/Spike/spike.tscn")
# var ending_time : float = 2.0
@export var enemy_spawn_state : EnemySpawnState
@export var idle_state : EnemyIdleState

var num_enemies_to_spawn : int = 3


func enter() -> void:
	var spawn_position : Vector3 = Vector3.ZERO
	var eye : Node3D = entity.enemy_spawner.spawn_enemy("AnglerEye", spawn_position)
	eye.set_variant(0)
	entity.link_health(eye)
	state_machine.set_state(idle_state)
	# entity.sprite_manager.play(animation_clip)
	# for i in range(4):
	# 	var angle : float = deg_to_rad(90 * i)
	# 	var direction : Vector3 = Vector3(cos(angle), 0, sin(angle))
	# 	summon_spike_straight_to_end(direction)	
	# audio_player.pitch_scale = 1.5 + randf() * 0.2
	# audio_player.play()
	# hitbox.set_active(true)
	# apply_velocity()
	# entity.knockback_component.set_knockbackable(false)
	# var bubbler_instance : Node = bubbler_scene.instantiate()
	# bubbler_instance.global_transform.origin = entity.global_transform.origin
	# entity.add_child(bubbler_instance)
	# bubbler_instance.start()
	# _original_direction = (target_position - entity.global_transform.origin).normalized()
	# _bullets_fired = 0

func run(_delta: float) -> void:
	check_state()
	
func check_state() -> void:
	var child_state : State = get_child_state()
	if child_state.is_complete:
		if child_state == enemy_spawn_state:
			num_enemies_to_spawn += 1
			idle_state.set_idle_duration(5.0)
			state_machine.set_state(idle_state)
		elif child_state == idle_state:
			enemy_spawn_state.set_spawn_info("SquidMinion", sample_positions_to_spawn())
			state_machine.set_state(enemy_spawn_state)

	
func on_eye_died() -> void:
	is_complete = true

func sample_positions_to_spawn() -> Array[Vector3]:
	var positions: Array[Vector3] = []
	while positions.size() < num_enemies_to_spawn:
		var all_indices: Array = range(entity.minion_spawn_points.size())
		all_indices.shuffle()
		for i : int in min(num_enemies_to_spawn - positions.size(), all_indices.size()):
			positions.append(entity.minion_spawn_points[all_indices[i]])
	return positions



# func exit() -> void:
# # 	pass
# 	hitbox.set_active(false)
	# entity.knockback_component.set_knockbackable(true)

# func summon_spike(position : Vector3, delay: float) -> void:
# 	var spike_instance : Node = spike_scene.instantiate()
# 	spike_instance.global_transform.origin = position
# 	entity.get_parent().add_child(spike_instance)
# 	spike_instance.setup(delay)

# func summon_spike_straight_to_end(direction : Vector3) -> void:
# 	var space_between_spikes : float = 0.5
# 	var flat_delay : float = 1.0
# 	var delay : float = 0.1
# 	var spike_count : int = 0
# 	while true:
# 		spike_count += 1
# 		var spawn_position : Vector3 = entity.global_transform.origin + direction * space_between_spikes * spike_count
# 		if (not entity.get_floor().check_in_bounds(spawn_position, 0.5)):
# 			break
# 		summon_spike(spawn_position, flat_delay + delay*spike_count)
	
# 	ending_time = flat_delay + delay * spike_count + 1.5

	
# func run(_delta: float) -> void:
	# check_state()
	# var num_bullets : int = get_num_bullets()
	# if get_elapsed_time() >= shooting_time / num_bullets * _bullets_fired and _bullets_fired < num_bullets:
	# 	var angle_between_bullets : float = deg_to_rad(angle_between_bullets_degrees)
	# 	var angle_offset : float = angle_between_bullets * (_bullets_fired - (num_bullets - 1) / 2.0)  # Center the bullets around the original direction
	# 	var rotated_direction : Vector3 = Vector3(
	# 		_original_direction.x * cos(angle_offset) - _original_direction.z * sin(angle_offset),
	# 		0,
	# 		_original_direction.x * sin(angle_offset) + _original_direction.z * cos(angle_offset)
	# 	)
	# 	shoot_dir(rotated_direction)
	# 	_bullets_fired += 1
	# if get_elapsed_time() >= ending_time:
	# 	is_complete = true

# func fixed_run(_delta: float) -> void:
# 	entity.velocity *= dampening
	# if entity.velocity.length() < 0.2:
	# 	hitbox.set_active(false)
	# if entity.velocity.length() < 1.0:
	# 	is_complete = true

# func set_target_position(position: Vector3) -> void:
# 	target_position = position

# func get_num_bullets() -> int:
# 	return base_num_bullets + GlobalStats.get_enemy_projectile_flat()
# func check_state() -> void:
# 	pass

# func apply_velocity()-> void:
# 	if target_position == null:
# 		return
# 	var direction : Vector3 = (target_position - entity.global_transform.origin)
# 	direction.y = 0
# 	direction = direction.normalized()
# 	var velocity : Vector3 = direction * attack_speed * GlobalStats.get_enemy_speed_multiplier()
# 	entity.velocity = velocity
