class_name CursedEffect extends EnemyStatusEffect

const COLOR : Color = Color(0.55, 0.3, 0.75)

static func make() -> CursedEffect:
	var effect : CursedEffect = CursedEffect.new()
	effect.name = StatusEffectNames.CURSED
	effect.persists_forever = true
	effect.is_conditional = false
	return effect


func get_color_overlay() -> Color:
	return COLOR
