class_name SpikeyEffect extends EnemyStatusEffect

const COLOR : Color = Color(1.0, 0.8, 0.2)
const DAMAGE_MULTIPLIER : int = 2

static func make() -> SpikeyEffect:
	var effect : SpikeyEffect = SpikeyEffect.new()
	effect.name = StatusEffectNames.SPIKEY
	effect.persists_forever = true
	effect.is_conditional = false
	return effect


func get_damage_multiplier() -> int:
	return DAMAGE_MULTIPLIER

func get_color_overlay() -> Color:
	return COLOR
