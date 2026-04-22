class_name BulkyEffect extends EnemyStatusEffect

const COLOR : Color = Color(0.55, 0.55, 0.6)
const DAMAGE_MULTIPLIER : float = 0.5

static func make(p_duration: float = -1.0) -> BulkyEffect:
	var effect : BulkyEffect = BulkyEffect.new()
	effect.name = "bulky"
	effect.duration = p_duration
	effect.time_remaining = p_duration
	effect.persists_forever = p_duration <= 0.0
	effect.is_conditional = false
	return effect


func modify_incoming_damage(damage: int, _attacker_hitbox: Hitbox) -> int:
	return int(ceil(damage * DAMAGE_MULTIPLIER))

func get_color_overlay() -> Color:
	return COLOR
