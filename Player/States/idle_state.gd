extends State
class_name IdleState

@export var animation : AnimationClip
var idle_duration : float = 3.0


var ebb_status_effect : StatusEffect = StatusEffect.create_conditional("slow")

func enter() -> void:
	entity.velocity = Vector3.ZERO
	entity.sprite_manager.play(animation)
	entity.position.y = 0
	if GlobalStats.get_ebb_on_stand():
		entity.gain_status_effect(ebb_status_effect, self)

func exit() -> void:
	if GlobalStats.get_ebb_on_stand():
		entity.lose_status_effect(ebb_status_effect, self)

		
func fixed_run(_delta: float) -> void:
	entity.velocity = Vector3.ZERO
	
func set_idle_duration(duration: float) -> void:
	idle_duration = duration

func run(_delta: float) -> void:
	if get_elapsed_time() >= idle_duration:
		is_complete = true
