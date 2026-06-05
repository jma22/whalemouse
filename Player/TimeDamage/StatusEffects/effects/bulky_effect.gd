class_name BulkyEffect extends EnemyStatusEffect

const COLOR : Color = Color(0.55, 0.55, 0.6)
const DAMAGE_MULTIPLIER : float = 0.5

static func make() -> BulkyEffect:
	var effect : BulkyEffect = BulkyEffect.new()
	effect.name = StatusEffectNames.BULKY
	effect.persists_forever = true
	effect.is_conditional = false
	return effect


# func modify_incoming_damage(info: DamageInfo) -> void:
# 	info.amount = int(ceil(info.amount * DAMAGE_MULTIPLIER))

func get_color_overlay() -> Color:
	return COLOR
