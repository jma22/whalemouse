extends State

class_name HurtState
@export var animation : AnimationClip
@export var knockback_strength: float = 5.0
@export var dampening: float = 0.9
@export var duration: float = 0.5

func enter() -> void:
	# player.sprite_manager.frames_per_second = fps
	var random_dir : Vector3 = Vector3(randf() * 2.0 - 1.0, 0, randf() * 2.0 - 1.0).normalized()
	entity.velocity = random_dir * knockback_strength


func fixed_run(delta: float) -> void:
	entity.velocity *= dampening
	entity.move_and_slide()

func run(delta: float) -> void:
	if get_elapsed_time() > duration:
		is_complete = true