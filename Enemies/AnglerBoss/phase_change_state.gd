extends State

class_name PhaseChangeState
@export var animation : AnimationClip
var idle_duration: float = 2.0

var target_position : Vector3 = Vector3.ZERO

func enter() -> void:
	# player.sprite_manager.frames_per_second = fps
	entity.sprite_manager.play(animation)
	entity.enemy_spawner.kill_all_enemies()
	# entity.velocity = Vector3.ZERO

func fixed_run(delta: float) -> void:
	entity.velocity = Vector3.ZERO

func set_idle_duration(duration: float) -> void:
	idle_duration = duration

func run(delta: float) -> void:
	if idle_duration < get_elapsed_time():
		is_complete = true