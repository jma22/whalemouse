extends State

class_name EnemyShootingState
var target_position : Vector3
@export var animation_clip : AnimationClip
@export var shooting_time : float = 0.3
@export var shooting_stun_time : float = 1.0
@export var num_bullets : int = 3
# @export var attack_speed : float = 12.0
# @export var dampening : float = 0.88
# @export var hitbox_active_time : float = 0.2
# @export var hitbox : Hitbox

# @export var audio_player : AudioStreamPlayer
var bullet : PackedScene = load("res://Enemies/Projectiles/damage_projectile.tscn")
var _original_direction : Vector3
var _bullets_fired : int = 0
var angle_between_bullets : float = PI / 18.0  # 10 degrees in radians

func enter() -> void:
	entity.sprite_manager.play(animation_clip)
	# audio_player.pitch_scale = 1.5 + randf() * 0.2
	# audio_player.play()
	# hitbox.set_active(true)
	# apply_velocity()
	# entity.knockback_component.set_knockbackable(false)
	# var bubbler_instance : Node = bubbler_scene.instantiate()
	# bubbler_instance.global_transform.origin = entity.global_transform.origin
	# entity.add_child(bubbler_instance)
	# bubbler_instance.start()
	_original_direction = (target_position - entity.global_transform.origin).normalized()
	_bullets_fired = 0


func shoot_dir(direction : Vector3) -> void:
	var bullet_instance : Node = bullet.instantiate()
	bullet_instance.global_transform.origin = entity.global_transform.origin
	entity.get_parent().add_child(bullet_instance)
	bullet_instance.setup(direction)

# func exit() -> void:
# # 	pass
# 	hitbox.set_active(false)
	# entity.knockback_component.set_knockbackable(true)

func run(_delta: float) -> void:
	# check_state()
	if get_elapsed_time() >= shooting_time / num_bullets * _bullets_fired and _bullets_fired < num_bullets:
		var angle_offset : float = angle_between_bullets * (_bullets_fired - (num_bullets - 1) / 2.0)  # Center the bullets around the original direction
		var rotated_direction : Vector3 = Vector3(
			_original_direction.x * cos(angle_offset) - _original_direction.z * sin(angle_offset),
			0,
			_original_direction.x * sin(angle_offset) + _original_direction.z * cos(angle_offset)
		)
		shoot_dir(rotated_direction)
		_bullets_fired += 1
	if get_elapsed_time() >= shooting_stun_time + shooting_time:
		is_complete = true

# func fixed_run(_delta: float) -> void:
# 	entity.velocity *= dampening
	# if entity.velocity.length() < 0.2:
	# 	hitbox.set_active(false)
	# if entity.velocity.length() < 1.0:
	# 	is_complete = true

func set_target_position(position: Vector3) -> void:
	target_position = position

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
