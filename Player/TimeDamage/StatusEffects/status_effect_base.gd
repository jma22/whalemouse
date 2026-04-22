class_name StatusEffectBase
extends RefCounted

var name : String = ""
var time_remaining : float = 0.0
var duration : float = 0.0

var is_conditional : bool = false
var is_enemy_effect : bool = false


func tick_effect(delta: float) -> void:
	time_remaining -= delta

func get_affects_enemy() -> bool:
	return is_enemy_effect

func get_multiplier() -> float:
	return 1.0
