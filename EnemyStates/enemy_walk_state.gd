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
	entity.velocity.x = direction.x * speed
	entity.velocity.z = direction.z * speed
	entity.move_and_slide()
	if (entity.global_transform.origin - target_position).length() < 0.1:
		is_complete = true