class_name HitboxBehavior
extends RefCounted

var name : String = ""


func modify_outgoing_damage(_info: DamageInfo, _target: Node3D) -> void:
	pass

func on_hit_landed(_info: DamageInfo, _target: Node3D) -> void:
	pass

func on_kill(_info: DamageInfo, _target: Node3D) -> void:
	pass
