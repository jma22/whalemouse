extends Node3D
class_name DashComponent
var dash_base_cooldown : float = 1.0
var dash_cooldown_timer : float = 0.0


func _process(_delta: float) -> void:
	_tick_dash_cooldown(_delta)

func set_dash_cooldown() -> void:
	dash_cooldown_timer = dash_base_cooldown

func _tick_dash_cooldown(delta: float) -> void:
	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer -= delta
		if dash_cooldown_timer < 0.0:
			dash_cooldown_timer = 0.0

func can_dash() -> bool:
	return GlobalStats.has_dash() and dash_cooldown_timer <= 0.0

func get_cooldown_progress() -> float:
	if dash_cooldown_timer <= 0.0:
		return 1.0
	return 1.0 - (dash_cooldown_timer / dash_base_cooldown)