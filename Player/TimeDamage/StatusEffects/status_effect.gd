extends RefCounted

class_name StatusEffect

var name : String = ""
var time_remaining : float = 0.0
var duration : float = 0.0


static func create(name: String, duration: float) -> StatusEffect:
	var effect : StatusEffect = StatusEffect.new()
	effect.name = name
	effect.time_remaining = duration
	effect.duration = duration
	return effect

func get_multiplier() -> float:
	match name:
		"freeze":
			return 0.0
		"slow":
			return 0.33
		"haste":
			return 1.5
		_:
			return 1.0

func get_icon_path() -> String:
	match name:
		"freeze":
			return "res://UI/HUD/StatusEffectIcons/freeze_icon.png"
		"slow":
			return "res://UI/HUD/StatusEffectIcons/slow_icon.png"
		"haste":
			return "res://UI/HUD/StatusEffectIcons/haste_icon.png"
		_:
			return ""

func tick_effect(delta: float) -> void:
	time_remaining -= delta
