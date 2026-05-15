class_name HitboxBehavior
extends RefCounted

var name : String = ""
var hitbox : Hitbox

func _dbg(msg: String) -> void:
	DebugLog.dbg("HitboxBehavior:" + name, msg)

func modify_outgoing_damage(_info: DamageInfo, _target: Node3D) -> void:
	_dbg("modify_outgoing_damage target=%s dmg=%s" % [DebugLog.entity_name(_target), _info.amount])
	_modify_outgoing_damage(_info, _target)

func _modify_outgoing_damage(_info: DamageInfo, _target: Node3D) -> void:
	pass

func on_hit_landed(_info: DamageInfo, _target: Node3D) -> void:
	_dbg("on_hit_landed target=%s dmg=%s" % [DebugLog.entity_name(_target), _info.amount])
	_on_hit_landed(_info, _target)

func _on_hit_landed(_info: DamageInfo, _target: Node3D) -> void:
	pass

func on_kill(_info: DamageInfo, _target: Node3D) -> void:
	_dbg("on_kill target=%s" % [DebugLog.entity_name(_target)])
	_on_kill(_info, _target)

func _on_kill(_info: DamageInfo, _target: Node3D) -> void:
	pass
