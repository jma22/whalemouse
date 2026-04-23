class_name HitboxBehavior
extends RefCounted

var name : String = ""


func modify_outgoing_damage(damage: int, _target: Node3D) -> int:
	return damage

func on_hit_landed(_attacker_hitbox: Hitbox, _target: Node3D) -> void:
	pass

func on_kill(_attacker_hitbox: Hitbox, _target: Node3D) -> void:
	pass
