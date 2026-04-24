class_name ShieldedEffect extends EnemyStatusEffect

const INVULNERABLE_DEBOUNCE : float = 0.1

var _charged : bool = true
var entity : Node3D
static func make() -> ShieldedEffect:
	var effect : ShieldedEffect = ShieldedEffect.new()
	effect.name = StatusEffectNames.SHIELDED
	effect.duration = -1.0
	effect.time_remaining = -1.0
	effect.persists_forever = true
	effect.is_conditional = false
	return effect


func _on_applied(entity_: Node3D) -> void:
	entity = entity_
	if entity and "shield_component" in entity and entity.shield_component:
		entity.shield_component.activate_shield()


func modify_incoming_damage(info: DamageInfo) -> void:
	_dbg("ShieldedEffect modifying incoming damage: currently charged=%s" % _charged)
	if not _charged:
		return
	_charged = false
	if entity and "shield_component" in entity and entity.shield_component:
		entity.shield_component.lose_shield()
	if entity and "invulnerable_component" in entity and entity.invulnerable_component:
		entity.invulnerable_component.set_invulnerable(true, INVULNERABLE_DEBOUNCE)
	persists_forever = false
	time_remaining = 0.0
	_dbg("shield absorbed hit → damage zeroed (%s → 0)" % info.amount)
	info.amount = 0
