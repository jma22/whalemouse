extends State

class_name EnemyShootingState

var target_position : Vector3
@export var animation_clip : AnimationClip
@export var shooting_stun_time : float = 1.0
@export var projectile_shooter : ProjectileShooter


func enter() -> void:
	entity.sprite_manager.play(animation_clip)
	if projectile_shooter.entity == null:
		projectile_shooter.setup(entity)
	var direction : Vector3 = (target_position - entity.global_transform.origin).normalized()
	projectile_shooter.start_burst(direction, entity.player)


func run(_delta: float) -> void:
	projectile_shooter.tick(_delta)
	if get_elapsed_time() >= shooting_stun_time + projectile_shooter.shooting_time:
		is_complete = true


func set_target_position(position: Vector3) -> void:
	target_position = position
