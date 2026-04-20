extends RefCounted

class_name StatusEffect

var name : String = ""
var time_remaining : float = 0.0
var duration : float = 0.0

var is_conditional : bool = false



static func create(name: String, duration: float) -> StatusEffect:
	var effect : StatusEffect = StatusEffect.new()
	effect.name = name
	effect.time_remaining = duration
	effect.duration = duration
	effect.is_conditional = false
	return effect

static func create_conditional(name: String) -> StatusEffect:
	var effect : StatusEffect = StatusEffect.new()
	effect.name = name
	effect.time_remaining = -1.0
	effect.duration = -1.0
	effect.is_conditional = true
	return effect


func get_multiplier() -> float:
	match name:
		"freeze":
			return 0.0
		"slow":
			return 0.33
		"haste":
			return 2.0
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
