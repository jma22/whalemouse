class_name StatusEffectFactory extends RefCounted

# Keyed by StringName so lookups avoid string hashing/allocs at call sites.
# Signature-normalized to (duration: float) — enemy effects ignore the duration
# and always persist forever; only haste/slow/freeze honor it.
static var _builders : Dictionary = {
	StatusEffectNames.BERSERK: func(_d: float) -> StatusEffectBase: return BerserkEffect.make(),
	StatusEffectNames.BULKY: func(_d: float) -> StatusEffectBase: return BulkyEffect.make(),
	StatusEffectNames.CURSED: func(_d: float) -> StatusEffectBase: return CursedEffect.make(),
	StatusEffectNames.FREEZE: FreezeEffect.make,
	StatusEffectNames.HASTE: HasteEffect.make,
	StatusEffectNames.INFESTED: func(_d: float) -> StatusEffectBase: return InfestedEffect.make(),
	StatusEffectNames.MARK: func(_d: float) -> StatusEffectBase: return MarkEffect.make(),
	StatusEffectNames.POISON: func(_d: float) -> StatusEffectBase: return PoisonEffect.make(),
	StatusEffectNames.SHIELDED: func(_d: float) -> StatusEffectBase: return ShieldedEffect.make(),
	StatusEffectNames.SLIPPERY: func(_d: float) -> StatusEffectBase: return SlipperyEffect.make(),
	StatusEffectNames.SLOW: SlowEffect.make,
	StatusEffectNames.SPIKEY: func(_d: float) -> StatusEffectBase: return SpikeyEffect.make(),
	StatusEffectNames.WITHER: func(_d: float) -> StatusEffectBase: return WitherEffect.make(),
	StatusEffectNames.EBBY: func(_d: float) -> StatusEffectBase: return EbbyEffect.make(),
	StatusEffectNames.FLOW: func(_d: float) -> StatusEffectBase: return FlowEffect.make(1),
}	

static func make(effect_name: StringName, duration: float = -1.0) -> StatusEffectBase:
	if effect_name not in _builders:
		push_error("StatusEffectFactory: unknown effect '%s'" % effect_name)
		return null
	return _builders[effect_name].call(duration)

static func has(effect_name: StringName) -> bool:
	return effect_name in _builders
