class_name FreezeEffect extends PlayerStatusEffect

static func make(p_duration: float) -> FreezeEffect:
	var effect : FreezeEffect = FreezeEffect.new()
	effect.name = StatusEffectNames.FREEZE
	effect.time_remaining = p_duration
	effect.duration = p_duration
	effect.is_conditional = false
	return effect

static func make_conditional() -> FreezeEffect:
	var effect : FreezeEffect = FreezeEffect.new()
	effect.name = StatusEffectNames.FREEZE
	effect.time_remaining = -1.0
	effect.duration = -1.0
	effect.is_conditional = true
	return effect


func modify_time_delta(_delta: float) -> float:
	return 0.0

func get_icon_path() -> String:
	return "res://UI/HUD/StatusEffectIcons/freeze_icon.png"
