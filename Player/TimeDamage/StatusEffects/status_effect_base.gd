class_name StatusEffectBase
extends RefCounted

var name : String = ""
var time_remaining : float = 0.0
var duration : float = 0.0

var is_conditional : bool = false
var is_enemy_effect : bool = false
var source : Object = null

var stacks : int = 1
var max_stacks : int = 1
var persists_forever : bool = false

func _dbg(msg: String) -> void:
	DebugLog.dbg("StatusEffect:" + name, msg)

func tick_effect(delta: float) -> void:
	time_remaining -= delta

func get_affects_enemy() -> bool:
	return is_enemy_effect


func modify_incoming_damage(_info: DamageInfo) -> void:
	pass

func modify_time_delta(delta: float) -> float:
	return delta

func get_speed_multiplier() -> float:
	return 1.0

func get_attack_speed_multiplier() -> float:
	return 1.0

func get_projectile_flat() -> int:
	return 0

func get_damage_multiplier() -> int:
	return 1

func on_hit_consumed(_entity: Node3D, _info: DamageInfo) -> bool:
	_dbg("on_hit_consumed entity=%s" % [DebugLog.entity_name(_entity)])
	return _on_hit_consumed(_entity, _info)

func _on_hit_consumed(_entity: Node3D, _info: DamageInfo) -> bool:
	return false

func on_killed_by_effect(_entity: Node3D) -> void:
	_dbg("on_killed_by_effect entity=%s " % [DebugLog.entity_name(_entity)])
	_on_killed_by_effect(_entity)

func _on_killed_by_effect(_entity: Node3D) -> void:
	pass

func on_entity_died(_entity: Node3D) -> void:
	_dbg("on_entity_died entity=%s" % [DebugLog.entity_name(_entity)])
	_on_entity_died(_entity)

func _on_entity_died(_entity: Node3D) -> void:
	pass

func on_applied(_entity: Node3D) -> void:
	_dbg("on_applied entity=%s" % [DebugLog.entity_name(_entity)])
	_on_applied(_entity)

func _on_applied(_entity: Node3D) -> void:
	pass

func on_dot_tick(_entity: Node3D, _delta: float) -> void:
	_on_dot_tick(_entity, _delta)

func _on_dot_tick(_entity: Node3D, _delta: float) -> void:
	pass

func on_expired(_entity: Node3D) -> bool:
	_dbg("on_expired entity=%s" % [DebugLog.entity_name(_entity)])
	return _on_expired(_entity)

func _on_expired(_entity: Node3D) -> bool:
	return true

func stack_with(existing: StatusEffectBase) -> void:
	_dbg("stack_with existing=%s stacks=%s" % [existing.name, existing.stacks])
	_stack_with(existing)

func _stack_with(existing: StatusEffectBase) -> void:
	existing.time_remaining += duration
	existing.duration += duration


func get_icon_path() -> String:
	return ""

func get_color_overlay() -> Color:
	return Color(1, 1, 1)
