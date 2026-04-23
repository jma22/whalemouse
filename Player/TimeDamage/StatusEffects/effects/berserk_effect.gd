class_name BerserkEffect extends EnemyStatusEffect

const COLOR : Color = Color(1.0, 0.45, 0.25)
const ATTACK_SPEED_MULTIPLIER : float = 2.0
const PROJECTILE_BONUS : int = 2

static func make() -> BerserkEffect:
	var effect : BerserkEffect = BerserkEffect.new()
	effect.name = StatusEffectNames.BERSERK
	effect.persists_forever = true
	effect.is_conditional = false
	return effect


func get_attack_speed_multiplier() -> float:
	return ATTACK_SPEED_MULTIPLIER

func get_projectile_flat() -> int:
	return PROJECTILE_BONUS

func get_color_overlay() -> Color:
	return COLOR
