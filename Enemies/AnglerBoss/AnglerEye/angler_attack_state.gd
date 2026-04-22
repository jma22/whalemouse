extends State

var target_position : Vector3
@export var animation_clip : AnimationClip
# @export var shooting_time : float = 0.3
# @export var shooting_stun_time : float = 1.0
# @export var base_num_bullets : int = 3
# @export var angle_between_bullets_degrees : float = 4

# @export var attack_speed : float = 12.0
# @export var dampening : float = 0.88
# @export var hitbox_active_time : float = 0.2
# @export var hitbox : Hitbox

# @export var audio_player : AudioStreamPlayer
var spike_scene : PackedScene = load("res://Enemies/Projectiles/Spike/spike.tscn")
var ending_time : float = 2.0
var rotated : bool = false

func enter() -> void:
	entity.sprite_manager.play(animation_clip)
	for i in range(4):
		var angle : float
		if not rotated:
			angle = deg_to_rad(90 * i)
		else:
			angle = deg_to_rad(90 * i + 45)
		var direction : Vector3 = Vector3(cos(angle), 0, sin(angle))
		summon_spike_straight_to_end(direction)	
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

func set_rotated(rotated_ : bool) -> void:
	rotated = rotated_

func summon_spike(position : Vector3, delay: float) -> void:
	var spike_instance : Node = spike_scene.instantiate()
	entity.get_parent().add_child(spike_instance)
	spike_instance.global_transform.origin = position
	var scale_ : float = StatCalculator.get_boss_attack_size_multiplier()
	spike_instance.scale = Vector3(scale_, scale_, scale_)
	spike_instance.setup(delay)

func summon_spike_straight_to_end(direction : Vector3) -> void:
	var space_between_spikes : float = 0.5
	var flat_delay : float = 1.0
	var delay : float = 0.1
	var spike_count : int = 0
	while true:
		spike_count += 1
		var spawn_position : Vector3 = entity.global_transform.origin + direction * space_between_spikes * spike_count
		if (not entity.get_floor().check_in_bounds(spawn_position, 0.3)):
			break
		summon_spike(spawn_position, flat_delay + delay*spike_count)
	
	ending_time = flat_delay + delay * spike_count + 1.5

	
func run(_delta: float) -> void:
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
	if get_elapsed_time() >= ending_time:
		is_complete = true

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
