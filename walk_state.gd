extends State

class_name WalkState
@export var animation : AnimationClip
@export var speed: float = 5.0
@export var fps: float = 4.0

func enter() -> void:
	# player.sprite_manager.frames_per_second = fps
	player.sprite_manager.play(animation)

func fixed_run(delta: float) -> void:
	var input_vector : Vector2 = player.get_input()
	if input_vector.length() == 0:
		is_complete = true
		return
	if input_vector.x < 0:
		player.sprite_manager.set_flip(true)
	elif input_vector.x > 0:
		player.sprite_manager.set_flip(false)
	player.velocity.x = input_vector.x * speed
	player.velocity.z = input_vector.y * speed
	player.move_and_slide()