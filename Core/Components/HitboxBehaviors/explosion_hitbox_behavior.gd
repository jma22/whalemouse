class_name ExplosionHitboxBehavior
extends HitboxBehavior

var explosion : PackedScene = load("res://Enemies/Projectiles/explosion.tscn")
var is_super_explosion : bool = false

static func make(is_super: bool) -> ExplosionHitboxBehavior:
	var behavior : ExplosionHitboxBehavior = ExplosionHitboxBehavior.new()
	behavior.name = "explosion"
	behavior.is_super_explosion = is_super
	return behavior

func _on_kill(info: DamageInfo, _target: Node3D) -> void:
	if StatCalculator.has_bomb_chain_reaction():
		var bomb_instance : Node3D = explosion.instantiate()
		_target.get_parent().add_child(bomb_instance)
		bomb_instance.global_transform.origin = _target.global_transform.origin
		bomb_instance.setup(info.get_source())
		_dbg("bomb_chain_reaction → spawned explosion at %s" % DebugLog.entity_name(_target))

func _on_hit_landed(_info: DamageInfo, _target: Node3D) -> void:
	if StatCalculator.has_poison_bombs():
		var poison_effect : PoisonEffect = StatusEffectFactory.make(StatusEffectNames.POISON)
		if _target is EnemyBase and _target.has_method("gain_status_effect"):
			_target.gain_status_effect(poison_effect, null)
			_dbg("poison_bombs → applied Poison to %s" % DebugLog.entity_name(_target))

func _modify_outgoing_damage(_info: DamageInfo, _target: Node3D) -> void:
	if is_super_explosion:
		_info.amount *= 2
		_dbg("super_explosion → doubled damage to %s" % _info.amount)
