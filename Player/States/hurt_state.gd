extends State

class_name HurtState
@export var animation : AnimationClip
@export var stun_duration: float = 0.6
@export var invulnerability_duration: float = 1.0

func enter() -> void:
	# player.sprite_manager.frames_per_second = fps
	entity.sprite_manager.play(animation)
	entity.set_invulnerable(true, invulnerability_duration)
	if StatCalculator.has_dash_reset_on_damage():
		entity.dash_component.reset_dash_cooldown()
		DebugLog.dbg("HurtState", "dash_reset_on_damage → dash cooldown reset")
	# var random_dir : Vector3 = Vector3(randf() * 2.0 - 1.0, 0, randf() * 2.0 - 1.0).normalized()
	# entity.velocity = random_dir * knockback_strength
	entity.position.y = 0

# func exit() -> void:
	# entity.set_invulnerable(false)

func fixed_run(_delta: float) -> void:
	entity.velocity = Vector3.ZERO

func run(_delta: float) -> void:
	if get_elapsed_time() > stun_duration:
		is_complete = true
