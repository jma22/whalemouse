extends Node3D
class_name HitStop

var is_in_hitstop : bool = false
var hitstop_timer : float = 0

func reset() -> void:
	is_in_hitstop = false
	hitstop_timer = 0.0

	
func _process(delta: float) -> void:
	if is_in_hitstop:
		hitstop_timer -= delta
		if hitstop_timer <= 0:
			is_in_hitstop = false


func start_hitstop(duration: float = 0.1) -> void:
	hitstop_timer = duration
	is_in_hitstop = true
		
