extends Node
class_name TimeDamageManager


@export var seconds_per_damage : float = 1.0
@export var player_health_component : HealthComponent
var _time_accumulator : float = 0.0

func _process(delta: float) -> void:
	_time_accumulator += delta
	if _time_accumulator >= seconds_per_damage:
		_time_accumulator -= seconds_per_damage
		do_damage()

func do_damage(damage: int = 1) -> void:
	if player_health_component:
		player_health_component.take_damage(damage)