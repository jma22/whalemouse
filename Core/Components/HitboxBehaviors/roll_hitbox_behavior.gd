class_name RollHitboxBehavior
extends HitboxBehavior

static func make() -> RollHitboxBehavior:
	var behavior : RollHitboxBehavior = RollHitboxBehavior.new()
	behavior.name = "roll"
	return behavior
