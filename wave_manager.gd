extends Node3D

class_name WaveManager
var current_wave : int = 0

func get_current_wave_info() -> WaveInfo:
	var wave_info : WaveInfo = WaveInfo.new()
	wave_info.wave_number = current_wave
	if wave_info.wave_number % 2 == 1:
		wave_info.room_type = "shrine"
		wave_info.blessings = ["heal", "damage"]
	else:
		wave_info.room_type = "combat"
		# wave_info.enemies_to_spawn = ["Goblin", "Orc", "Troll"]
	return wave_info