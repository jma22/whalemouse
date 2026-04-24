extends State

class_name WalkState
@export var animation : AnimationClip
@export var speed: float = 5.0
@export var fps: float = 4.0

func enter() -> void:
	# player.sprite_manager.frames_per_second = fps
	entity.sprite_manager.play(animation)

func fixed_run(_delta: float) -> void:
	var input_vector : Vector2 = entity.get_input()
	if input_vector.length() == 0:
		is_complete = true
		return
	if input_vector.x < 0:
		entity.sprite_manager.set_flip(true)
	elif input_vector.x > 0:
		entity.sprite_manager.set_flip(false)
	entity.velocity.x = input_vector.x * get_speed()
	entity.velocity.z = input_vector.y * get_speed()

func get_speed() -> float:
	# if entity.status_effect_manager.has_status_effect():
	# 	return speed + StatCalculator.speed_during_status() + StatCalculator.get_flat_speed()
	return (speed + StatCalculator.get_movement_speed_flat()) * StatCalculator.get_speed_up_multiplier() * StatCalculator.get_slow_down_multiplier() * entity.status_effect_manager.get_speed_multiplier_from_status()
