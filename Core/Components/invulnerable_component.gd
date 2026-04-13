extends Node3D
class_name InvulnerableComponent
var is_invulnerable : bool = false
var invulnerability_timer : float = 0.0

func set_invulnerable(value: bool, duration: float = 0.0) -> void:
	is_invulnerable = value
	invulnerability_timer = duration

func _process(delta: float) -> void:
	if is_invulnerable and invulnerability_timer > 0.0:
		invulnerability_timer -= delta
		if invulnerability_timer <= 0.0:
			is_invulnerable = false

func is_currently_invulnerable() -> bool:
	return is_invulnerable