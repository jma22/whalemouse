class_name WhaleHitboxBehavior
extends HitboxBehavior

var explosion_scene : PackedScene = load("res://Enemies/Projectiles/explosion.tscn")
static func make() -> WhaleHitboxBehavior:
	var behavior : WhaleHitboxBehavior = WhaleHitboxBehavior.new()
	behavior.name = "whale"
	return behavior

func _on_hit_landed(_info: DamageInfo, _target: Node3D) -> void:
	if StatCalculator.has_bomber_whale():
		var explosion_instance : Node3D = explosion_scene.instantiate()
		_target.get_parent().add_child(explosion_instance)
		explosion_instance.global_transform.origin = _target.global_transform.origin
		explosion_instance.global_transform.origin.y = 0.0
		explosion_instance.setup(hitbox.get_source())
		_dbg("bomber_whale → spawned explosion at %s" % DebugLog.entity_name(_target))
	if StatCalculator.has_poison_beluga():
		if _target.has_method("gain_status_effect"):
			var poison : EnemyStatusEffect = StatusEffectFactory.make(StatusEffectNames.POISON) as EnemyStatusEffect
			_target.gain_status_effect(poison, _info.get_source())
			_dbg("poison_beluga → applied Poison to %s" % DebugLog.entity_name(_target))
	if StatCalculator.has_marking_beluga():
		if _target.has_method("gain_status_effect"):
			var mark : MarkEffect = MarkEffect.make()
			_target.gain_status_effect(mark, _info.get_source())
			_target.gain_status_effect(mark, _info.get_source())
			_dbg("marking_beluga → applied Mark to %s" % DebugLog.entity_name(_target))
	

func _modify_outgoing_damage(_info: DamageInfo, _target: Node3D) -> void:
	if StatCalculator.beluga_special_killer():
		if _target is EnemyBase and _target.status_effect_manager.has_status_effect():
			_info.amount *= 2
			_dbg("beluga_special_killer: %s has effects → dmg doubled to %s" % [DebugLog.entity_name(_target), _info.amount])
		else:
			_dbg("beluga_special_killer: %s has no effects → dmg unchanged at %s" % [DebugLog.entity_name(_target), _info.amount])



func on_kill(_info: DamageInfo, _target: Node3D) -> void:
	_dbg("WhaleHitboxBehavior on_kill triggered for %s" % DebugLog.entity_name(_target))
	if StatCalculator.orbs_on_beluga_kill() > 0:
		if _target is EnemyBase:
			var spawner : Node3D = (load("res://Collectibles/xp_spawner.tscn") as PackedScene).instantiate()
			_target.get_parent().add_child(spawner)
			spawner.global_transform.origin = _target.global_transform.origin
			spawner.global_transform.origin.y = 0.0
			spawner.setup_outwards(StatCalculator.orbs_on_beluga_kill(), GlobalStats.player, CollectibleSpawner.OrbType.TIME, _target.get_floor())
			_dbg("orbs_on_beluga_kill → spawned %s orbs at %s" % [StatCalculator.orbs_on_beluga_kill(), DebugLog.entity_name(_target)])
	
	if StatCalculator.on_beluga_kill_cd_refund_percent() > 0:
		_dbg("on_beluga_kill_cd_refund_percent → attempting to refund whale cooldown for %s" % DebugLog.entity_name(hitbox.get_source()))
		if hitbox.get_source() and hitbox.get_source().has_method("refund_whale_cooldown"):
			hitbox.get_source().refund_whale_cooldown(StatCalculator.on_beluga_kill_cd_refund_percent())
			_dbg("on_beluga_kill_cd_refund_percent → refunded %s%% whale cooldown for %s" % [
				StatCalculator.on_beluga_kill_cd_refund_percent() * 100, DebugLog.entity_name(hitbox.get_source())
			])
			
	if StatCalculator.on_beluga_kill_size_grow():
		GlobalStats.current_run_stats["whale_size"] += 1
		_dbg("on_beluga_kill_size_grow → increased whale_size to %s" % GlobalStats.current_run_stats["whale_size"])