class_name WitherEffect extends EnemyStatusEffect

const COLOR : Color = Color(0.55, 0.6, 0.35)

static func make() -> WitherEffect:
	var effect : WitherEffect = WitherEffect.new()
	effect.name = StatusEffectNames.WITHER
	effect.persists_forever = true
	effect.is_conditional = false
	return effect


func on_applied(entity: Node3D) -> void:
	if entity and "health_component" in entity and entity.health_component:
		entity.health_component.current_health = 1

func get_color_overlay() -> Color:
	return COLOR
