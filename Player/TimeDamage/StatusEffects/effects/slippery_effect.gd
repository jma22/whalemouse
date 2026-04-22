class_name SlipperyEffect extends EnemyStatusEffect

const COLOR : Color = Color(0.5, 0.85, 1.0)
const SPEED_MULTIPLIER : float = 1.6

static func make(p_duration: float = -1.0) -> SlipperyEffect:
	var effect : SlipperyEffect = SlipperyEffect.new()
	effect.name = "slippery"
	effect.duration = p_duration
	effect.time_remaining = p_duration
	effect.persists_forever = p_duration <= 0.0
	effect.is_conditional = false
	return effect


func get_speed_multiplier() -> float:
	return SPEED_MULTIPLIER

func get_color_overlay() -> Color:
	return COLOR
