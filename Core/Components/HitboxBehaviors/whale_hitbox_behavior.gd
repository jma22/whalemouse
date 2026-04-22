class_name WhaleHitboxBehavior
extends HitboxBehavior

static func make() -> WhaleHitboxBehavior:
	var behavior : WhaleHitboxBehavior = WhaleHitboxBehavior.new()
	behavior.name = "whale"
	return behavior
