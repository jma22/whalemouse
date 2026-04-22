class_name SlowEffect extends PlayerStatusEffect

const TIME_MULTIPLIER : float = 0.33

static func make(p_duration: float) -> SlowEffect:
	var effect : SlowEffect = SlowEffect.new()
	effect.name = StatusEffectNames.SLOW
	effect.time_remaining = p_duration
	effect.duration = p_duration
	effect.is_conditional = false
	return effect

static func make_conditional() -> SlowEffect:
	var effect : SlowEffect = SlowEffect.new()
	effect.name = StatusEffectNames.SLOW
	effect.time_remaining = -1.0
	effect.duration = -1.0
	effect.is_conditional = true
	return effect


func modify_time_delta(delta: float) -> float:
	return delta * TIME_MULTIPLIER

func get_icon_path() -> String:
	return "res://UI/HUD/StatusEffectIcons/slow_icon.png"
