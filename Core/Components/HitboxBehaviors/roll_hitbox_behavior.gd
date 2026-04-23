class_name RollHitboxBehavior
extends HitboxBehavior

static func make() -> RollHitboxBehavior:
	var behavior : RollHitboxBehavior = RollHitboxBehavior.new()
	behavior.name = "roll"
	return behavior


func on_hit_landed(_info: DamageInfo, _target: Node3D) -> void:
	if StatCalculator.has_marking_dash():
		if _target.has_method("gain_status_effect"):
			var mark : MarkEffect = MarkEffect.make()
			_target.gain_status_effect(mark)

func modify_outgoing_damage(_info: DamageInfo, _target: Node3D) -> void:
	if StatCalculator.dash_damages_status():
		if _target is EnemyBase and _target.status_effect_manager.has_status_effect():
			_info.amount = 1
		else:
			_info.amount = 0