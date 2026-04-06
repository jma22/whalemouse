extends Node
class_name TimeDamageManager


# @export var seconds_per_damage : float = 1.0
var player : Node3D
var _time_accumulator : float = 0.0
@export var wave_manager : WaveManager

func reset() -> void:
	_time_accumulator = 0.0

func setup(player : Node3D) -> void:
	self.player = player

func _process(delta: float) -> void:
	var wave_info := wave_manager.get_current_wave_info()
	
	# Stop timer if not in combat
	if wave_info.room_type != "combat":
		return

	_time_accumulator += delta
	
	var seconds_per_damage : float = GlobalStats.get_seconds_per_damage()
	if _time_accumulator >= seconds_per_damage:
		GlobalStats.add_time_survived(seconds_per_damage)
		_time_accumulator -= seconds_per_damage
		do_damage()
		
		if player.health_component and player.health_component.is_dead():
			player.on_die()

func do_damage(damage: int = 1) -> void:
	if player.health_component:
		player.health_component.take_damage(damage)

func get_progress() -> float:
	var seconds_per_damage : float = GlobalStats.get_seconds_per_damage()
	if seconds_per_damage == 0:
		return 0.0
	return _time_accumulator / seconds_per_damage
