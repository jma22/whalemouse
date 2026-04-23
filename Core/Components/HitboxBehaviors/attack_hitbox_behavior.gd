class_name AttackHitboxBehavior
extends HitboxBehavior

static func make() -> AttackHitboxBehavior:
	var behavior : AttackHitboxBehavior = AttackHitboxBehavior.new()
	behavior.name = "attack"
	return behavior

func on_hit_landed(_info: DamageInfo, _target: Node3D) -> void:
	if StatCalculator.has_poison_ebb_attack():
		var source : Node3D = hitbox.source
		if source and "status_effect_manager" in source:
			if source.status_effect_manager.has_status_effect(StatusEffectNames.SLOW):
				if _target.has_method("gain_status_effect"):
					var poison : EnemyStatusEffect = StatusEffectFactory.make(StatusEffectNames.POISON) as EnemyStatusEffect
					_target.gain_status_effect(poison, hitbox)
