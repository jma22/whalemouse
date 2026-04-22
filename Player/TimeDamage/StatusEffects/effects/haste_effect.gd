class_name HasteEffect extends PlayerStatusEffect

const TIME_MULTIPLIER : float = 2.0

static func make(p_duration: float) -> HasteEffect:
	var effect : HasteEffect = HasteEffect.new()
	effect.name = "haste"
	effect.time_remaining = p_duration
	effect.duration = p_duration
	effect.is_conditional = false
	return effect

static func make_conditional() -> HasteEffect:
	var effect : HasteEffect = HasteEffect.new()
	effect.name = "haste"
	effect.time_remaining = -1.0
	effect.duration = -1.0
	effect.is_conditional = true
	return effect


func modify_time_delta(delta: float) -> float:
	return delta * TIME_MULTIPLIER

func get_icon_path() -> String:
	return "res://UI/HUD/StatusEffectIcons/haste_icon.png"
