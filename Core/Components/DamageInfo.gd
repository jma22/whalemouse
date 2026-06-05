class_name DamageInfo
extends RefCounted

enum DamageType { MELEE, BULLET, INK, SPIKE, BOMB, DASH, THORN , POISON, TIME_TICK, BOSS_PHASE}

var amount : int
var source : Object ## most recent owner, can be timedamagemanager, can be poison_effect, can be hitbox
var owner_entity : Node3D ## root owner
var damage_type : DamageType = DamageType.MELEE
# var was_marked : bool = false
var mark_damage : int = 0
var was_shielded : bool = false
# var hitbox : Hitbox

# func get_source() -> Node3D:
# 	return source if source != null else owner_entity

static func create(_source : Object, _damage_type : DamageType) -> DamageInfo:
	var damage_info : DamageInfo = DamageInfo.new()
	damage_info.source = _source
	damage_info.amount = 0
	damage_info.damage_type = _damage_type
	return damage_info

func base_damage(_amount : int) -> DamageInfo:
	amount = _amount
	return self

func set_owner(owner : Node3D) -> DamageInfo:
	owner_entity = owner
	return self

func add_mark_damage(_amount : int) -> DamageInfo:
	mark_damage = _amount
	return self

func set_was_shielded() -> DamageInfo:
	was_shielded = true
	return self

func get_damage_amount() -> int:
	if was_shielded:
		return 0
	return amount + mark_damage
