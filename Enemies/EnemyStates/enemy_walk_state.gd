extends State

class_name EnemyWalkState
@export var animation : AnimationClip
@export var speed: float = 1.0
@export var fps: float = 4.0

var target_position : Vector3 = Vector3.ZERO

func enter() -> void:
	# player.sprite_manager.frames_per_second = fps
	entity.sprite_manager.play(animation)

func set_target_position(target: Vector3) -> void:
	self.target_position = target

func fixed_run(delta: float) -> void:
	var direction : Vector3 = (target_position - entity.global_transform.origin).normalized()
	entity.velocity.x = direction.x * speed * GlobalStats.get_enemy_speed_multiplier()
	entity.velocity.z = direction.z * speed * GlobalStats.get_enemy_speed_multiplier()
	## add perlin noise
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	var noise_value_x = noise.get_noise_1d(Time.get_ticks_msec() * 0.1)
	entity.velocity.x += noise_value_x * 1.5
	var noise_value_z = noise.get_noise_1d(Time.get_ticks_msec()  * 0.1)
	entity.velocity.z += noise_value_z * 1.5

	if (entity.global_transform.origin - target_position).length() < 0.1:
		is_complete = true