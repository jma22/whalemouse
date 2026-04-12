extends RefCounted

class_name StatusEffect

var name = ""
var time_remaining : float = 0.0
var duration : float = 0.0


static func create(name: String, duration: float) -> StatusEffect:
	var effect = StatusEffect.new()
	effect.name = name
	effect.time_remaining = duration
	effect.duration = duration
	return effect

func get_multiplier() -> float:
	match name:
		"freeze":
			return 0.0
		"slow":
			return 0.5
		"haste":
			return 1.5
		_:
			return 1.0

func tick_effect(delta: float) -> void:
	time_remaining -= delta
