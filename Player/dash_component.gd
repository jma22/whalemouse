extends Node3D
class_name DashComponent
var dash_base_cooldown : float = 1.5
var dash_cooldown_timer : float = 0.0


func _process(_delta: float) -> void:
	_tick_dash_cooldown(_delta)

func set_dash_cooldown() -> void:
	dash_cooldown_timer = get_dash_cooldown()

func _tick_dash_cooldown(delta: float) -> void:
	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer -= delta
		if dash_cooldown_timer < 0.0:
			dash_cooldown_timer = 0.0

func reset_dash_cooldown() -> void:
	dash_cooldown_timer = 0.0

func can_dash() -> bool:
	return StatCalculator.has_dash() and dash_cooldown_timer <= 0.0

func get_cooldown_progress() -> float:
	if dash_cooldown_timer <= 0.0:
		return 1.0
	return 1.0 - (dash_cooldown_timer / (get_dash_cooldown()))

func get_dash_cooldown() -> float:
	return dash_base_cooldown * StatCalculator.get_dash_cooldown_reduction() * StatCalculator.get_dash_cooldown_increase() * StatCalculator.get_suicide_dash_cooldown_decrease()