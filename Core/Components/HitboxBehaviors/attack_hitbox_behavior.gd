class_name AttackHitboxBehavior
extends HitboxBehavior

static func make() -> AttackHitboxBehavior:
	var behavior : AttackHitboxBehavior = AttackHitboxBehavior.new()
	behavior.name = "attack"
	return behavior
