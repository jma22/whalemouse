class_name WhaleHitboxBehavior
extends HitboxBehavior

static func make() -> WhaleHitboxBehavior:
	var behavior : WhaleHitboxBehavior = WhaleHitboxBehavior.new()
	behavior.name = "whale"
	return behavior

func on_hit_landed(_info: DamageInfo, _target: Node3D) -> void:
	if StatCalculator.has_bomber_whale():
		var explosion : PackedScene = preload("res://Enemies/Projectiles/Explosion.tscn")
		var explosion_instance : Node3D = explosion.instantiate()
		_target.get_parent().add_child(explosion_instance)
		explosion_instance.global_transform.origin = _target.global_transform.origin
		explosion_instance.global_transform.origin.y = 0.0
		explosion_instance.setup(hitbox.source)
	if StatCalculator.has_poison_beluga():
		if _target.has_method("gain_status_effect"):
			var poison : EnemyStatusEffect = StatusEffectFactory.make(StatusEffectNames.POISON) as EnemyStatusEffect
			_target.gain_status_effect(poison, hitbox)
	if StatCalculator.has_marking_beluga():
		if _target.has_method("gain_status_effect"):
			var mark : MarkEffect = MarkEffect.make()
			_target.gain_status_effect(mark, hitbox)
			_target.gain_status_effect(mark, hitbox)
