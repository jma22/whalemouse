class_name ExplosionHitboxBehavior
extends HitboxBehavior

static func make() -> ExplosionHitboxBehavior:
	var behavior : ExplosionHitboxBehavior = ExplosionHitboxBehavior.new()
	behavior.name = "explosion"
	return behavior
