class_name ExplosionHitboxBehavior
extends HitboxBehavior

var explosion : PackedScene = load("res://Enemies/Projectiles/explosion.tscn")


static func make() -> ExplosionHitboxBehavior:
	var behavior : ExplosionHitboxBehavior = ExplosionHitboxBehavior.new()
	behavior.name = "explosion"
	return behavior

func on_kill(_attacker_hitbox: Hitbox, _target: Node3D) -> void:
	var bomb_instance : Node3D = explosion.instantiate()
	_target.get_parent().add_child(bomb_instance)
	bomb_instance.global_transform.origin = _target.global_transform.origin
	bomb_instance.setup(2.0)
