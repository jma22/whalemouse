class_name BerserkEffect extends EnemyStatusEffect

const COLOR : Color = Color(1.0, 0.45, 0.25)
const ATTACK_SPEED_MULTIPLIER : float = 1.5
const PROJECTILE_BONUS : int = 1

static func make(p_duration: float = -1.0) -> BerserkEffect:
	var effect : BerserkEffect = BerserkEffect.new()
	effect.name = "berserk"
	effect.duration = p_duration
	effect.time_remaining = p_duration
	effect.persists_forever = p_duration <= 0.0
	effect.is_conditional = false
	return effect


func get_attack_speed_multiplier() -> float:
	return ATTACK_SPEED_MULTIPLIER

func get_projectile_flat() -> int:
	return PROJECTILE_BONUS

func get_color_overlay() -> Color:
	return COLOR
