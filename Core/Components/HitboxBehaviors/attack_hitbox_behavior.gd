class_name AttackHitboxBehavior
extends HitboxBehavior

static func make() -> AttackHitboxBehavior:
	var behavior : AttackHitboxBehavior = AttackHitboxBehavior.new()
	behavior.name = "attack"
	return behavior

func _on_hit_landed(_info: DamageInfo, _target: Node3D) -> void:
	if StatCalculator.has_poison_ebb_attack():
		var source : Node3D = hitbox.get_owner_entity()
		if source and "status_effect_manager" in source:
			if source.status_effect_manager.has_status_effect(StatusEffectNames.SLOW):
				_dbg("PoisonEbbAttack: source has Slow → applying Poison to target %s" % DebugLog.entity_name(_target))	
				if _target.has_method("gain_status_effect"):
					var poison : EnemyStatusEffect = StatusEffectFactory.make(StatusEffectNames.POISON) as EnemyStatusEffect
					_target.gain_status_effect(poison, hitbox)
					_dbg("PoisonEbbAttack → applied Poison to %s (source has Slow)" % DebugLog.entity_name(_target))
			else:
				_dbg("PoisonEbbAttack: source does not have Slow → not applying Poison to target %s" % DebugLog.entity_name(_target))
		else:
			_dbg("PoisonEbbAttack: source is invalid or has no status_effect_manager → cannot apply Poison to target %s" % DebugLog.entity_name(_target))

func _on_kill(_info: DamageInfo, _target: Node3D) -> void:
	var kill_orb_num : int = StatCalculator.get_jump_kill_orb_num()
	var kill_orb_chance : float = 0.2
	if kill_orb_num > 0:
		if _target is EnemyBase:
			var roll : float = randf()
			if roll < kill_orb_chance:
				var spawner : Node3D = (load("res://Collectibles/xp_spawner.tscn") as PackedScene).instantiate()
				_target.get_parent().add_child(spawner)
				spawner.global_transform.origin = _target.global_transform.origin
				spawner.global_transform.origin.y = 0.0
				spawner.setup_outwards(kill_orb_num, _target.player, CollectibleSpawner.OrbType.TIME, _target.get_floor())
				_dbg("jump_kill_orb → spawned orb on %s rolled a %.2f but needed %.2f" % [DebugLog.entity_name(_target), roll * 100, kill_orb_chance * 100])
			else:
				_dbg("jump_kill_orb → rolled on %s but did not proc orb (chance %.2f%%). (Rolled a %.2f)" % [
					DebugLog.entity_name(_target), kill_orb_chance * 100, roll * 100
				])
