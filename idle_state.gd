extends State
class_name IdleState

@export var animation : AnimationClip
var idle_duration : float = 3.0

func enter() -> void:
	player.sprite_manager.play(animation)

func set_idle_duration(duration: float) -> void:
	idle_duration = duration

func run(delta: float) -> void:
	if get_elapsed_time() >= idle_duration:
		is_complete = true
