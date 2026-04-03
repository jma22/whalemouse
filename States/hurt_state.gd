extends State

class_name HurtState
@export var animation : AnimationClip
@export var knockback_strength: float = 3.0
@export var dampening: float = 0.85
@export var duration: float = 0.6

func enter() -> void:
	# player.sprite_manager.frames_per_second = fps
	entity.sprite_manager.play(animation)
	entity.set_invulnerable(true)
	var random_dir : Vector3 = Vector3(randf() * 2.0 - 1.0, 0, randf() * 2.0 - 1.0).normalized()
	entity.velocity = random_dir * knockback_strength
	entity.position.y = 0

func exit() -> void:
	entity.set_invulnerable(false)

func fixed_run(delta: float) -> void:
	entity.velocity *= dampening

func run(delta: float) -> void:
	if get_elapsed_time() > duration:
		is_complete = true
