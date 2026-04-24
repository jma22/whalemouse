class_name DamageInfo
extends RefCounted

enum DamageType { MELEE, BULLET, INK, SPIKE, BOMB, DASH, THORN , POISON,}

var amount : int
var source : Node3D
var owner_entity : Node3D
var damage_type : DamageType = DamageType.MELEE
var was_marked : bool = false
var hitbox : Hitbox

func get_source() -> Node3D:
	return source if source != null else owner_entity
