class_name SlipperyEffect extends EnemyStatusEffect

const COLOR : Color = Color(0.5, 0.85, 1.0)
const SPEED_MULTIPLIER : float = 1.8

static func make() -> SlipperyEffect:
	var effect : SlipperyEffect = SlipperyEffect.new()
	effect.name = StatusEffectNames.SLIPPERY
	effect.persists_forever = true
	effect.is_conditional = false
	return effect


func get_speed_multiplier() -> float:
	return SPEED_MULTIPLIER

func get_color_overlay() -> Color:
	return COLOR
