class_name CursedEffect extends EnemyStatusEffect

const COLOR : Color = Color(0.55, 0.3, 0.75)

static func make(p_duration: float) -> CursedEffect:
	var effect : CursedEffect = CursedEffect.new()
	effect.name = "cursed"
	effect.time_remaining = p_duration
	effect.duration = p_duration
	effect.is_conditional = false
	return effect


func get_color_overlay() -> Color:
	return COLOR
