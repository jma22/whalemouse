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
	return false

func on_owner_killed(_entity: Node3D, _killer: Object) -> void:
	pass

func on_applied(_entity: Node3D) -> void:
	pass

func on_dot_tick(_entity: Node3D, _delta: float) -> void:
	pass

# Called when time_remaining hits 0. Return true to have the manager remove
# this effect. Return false to keep it (the effect is expected to reset its
# own time_remaining in that case).
func on_expired(_entity: Node3D) -> bool:
	return true

# Called when gain_status_effect receives this effect and an entry with the
# same name already exists. `self` is the incoming instance (discarded
# afterward); mutate `existing` to reflect the merge. Default behavior:
# duration stacks.
func stack_with(existing: StatusEffectBase) -> void:
	existing.time_remaining += duration
	existing.duration += duration


func get_icon_path() -> String:
	return ""

func get_color_overlay() -> Color:
	return Color(1, 1, 1)
