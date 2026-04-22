class_name PlayerStatusEffect extends StatusEffectBase

static func create(name: String, duration: float) -> PlayerStatusEffect:
	var effect : PlayerStatusEffect = PlayerStatusEffect.new()
	effect.name = name
	effect.time_remaining = duration
	effect.duration = duration
	effect.is_conditional = false
	effect.is_enemy_effect = false
	return effect

static func create_conditional(name: String) -> PlayerStatusEffect:
	var effect : PlayerStatusEffect = PlayerStatusEffect.new()
	effect.name = name
	effect.time_remaining = -1.0
	effect.duration = -1.0
	effect.is_conditional = true
	effect.is_enemy_effect = false
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

# func tick_effect(delta: float) -> void:
# 	time_remaining -= delta

