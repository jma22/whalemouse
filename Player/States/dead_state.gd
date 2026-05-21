extends State

class_name DeadState

@export var animation : AnimationClip
# @export var stun_duration: float = 0.4
# @export var invulnerability_duration: float = 0.6

func enter() -> void:
	# player.sprite_manager.frames_per_second = fps
	entity.sprite_manager.play(animation)
	entity.set_invulnerable(true)
	entity.position.y = 0
	entity.disable_input = true
	# var death_tween : Tween = create_tween()
	# death_tween.tween_callback(SceneManager.gameover_animation)
	SceneManager.gameover_animation()

# func exit() -> void:
	# entity.set_invulnerable(false)

func fixed_run(_delta: float) -> void:
	entity.velocity = Vector3.ZERO

# func run(_delta: float) -> void:
# 	if get_elapsed_time() > stun_duration:
# 		is_complete = true

