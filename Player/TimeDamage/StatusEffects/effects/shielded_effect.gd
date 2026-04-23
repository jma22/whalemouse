class_name ShieldedEffect extends EnemyStatusEffect

const INVULNERABLE_DEBOUNCE : float = 0.1

var _charged : bool = true

static func make() -> ShieldedEffect:
	var effect : ShieldedEffect = ShieldedEffect.new()
	effect.name = StatusEffectNames.SHIELDED
	effect.duration = -1.0
	effect.time_remaining = -1.0
	effect.persists_forever = true
	effect.is_conditional = false
	return effect


func on_applied(entity: Node3D) -> void:
	if entity and "shield_component" in entity and entity.shield_component:
		entity.shield_component.activate_shield()


func modify_incoming_damage(info: DamageInfo) -> void:
	if not _charged:
		return
	_charged = false
	if source and "shield_component" in source and source.shield_component:
		source.shield_component.lose_shield()
	if source and "invulnerable_component" in source and source.invulnerable_component:
		source.invulnerable_component.set_invulnerable(true, INVULNERABLE_DEBOUNCE)
	persists_forever = false
	time_remaining = 0.0
	info.amount = 0
