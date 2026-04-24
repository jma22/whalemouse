class_name RollHitboxBehavior
extends HitboxBehavior

static func make() -> RollHitboxBehavior:
	var behavior : RollHitboxBehavior = RollHitboxBehavior.new()
	behavior.name = "roll"
	return behavior


func _on_hit_landed(_info: DamageInfo, _target: Node3D) -> void:
	if StatCalculator.has_marking_dash():
		if _target.has_method("gain_status_effect"):
			var mark : MarkEffect = MarkEffect.make()
			_target.gain_status_effect(mark, null)
			_dbg("marking_dash → applied Mark to %s" % DebugLog.entity_name(_target))

	var dash_orb_num : int = StatCalculator.get_midas_dash_touch_num()
	var dash_orb_chance : float = 0.2
	if dash_orb_num > 0:
		if _target is EnemyBase:
			var roll : float = randf()
			if roll < dash_orb_chance:
				var spawner : Node3D = (load("res://Collectibles/xp_spawner.tscn") as PackedScene).instantiate()
				_target.get_parent().add_child(spawner)
				spawner.global_transform.origin = _target.global_transform.origin
				spawner.global_transform.origin.y = 0.0
				spawner.setup_outwards(dash_orb_num, _target.player, CollectibleSpawner.OrbType.TIME, _target.get_floor())
				_dbg("midas_dash_touch → spawned orb on %s. Rolled %.2f with odds %.2f%%" % [DebugLog.entity_name(_target), roll * 100, dash_orb_chance * 100])
			else:
				_dbg("midas_dash_touch → rolled on %s but did not proc orb (chance %.2f%%). (Rolled a %.2f)" % [
					DebugLog.entity_name(_target), dash_orb_chance * 100, roll * 100
				])
		else:
			_dbg("midas_dash_touch → target %s is not EnemyBase, cannot spawn orb" % DebugLog.entity_name(_target))

func _modify_outgoing_damage(_info: DamageInfo, _target: Node3D) -> void:
	if StatCalculator.dash_damages_status():
		if _target is EnemyBase and _target.status_effect_manager.has_status_effect():
			_info.amount = 1
			_dbg("dash_damages_status: %s has effects → dmg→1" % DebugLog.entity_name(_target))
		else:
			_info.amount = 0
			_dbg("dash_damages_status: %s has no effects → dmg→0" % DebugLog.entity_name(_target))

	_dbg("RollHitboxBehavior modifying damage to %s" % _info.amount)
