extends Node3D

class_name WaveManager
var current_wave : int = 0

func get_current_wave_info() -> WaveInfo:
	var wave_info : WaveInfo = WaveInfo.new()
	wave_info.wave_number = current_wave
	# every 2 and 4 waves are shrine waves
	# every 5 is a curse
	if wave_info.wave_number == 7:
		wave_info.room_type = "shrine"
		wave_info.blessings = ["whale_level"]
		return wave_info
	
	if wave_info.wave_number == 0:
		wave_info.room_type = "shrine"
		wave_info.blessings =  GlobalStats.get_two_random_blessing()
		return wave_info

	if wave_info.wave_number % 10 == 5:
		wave_info.room_type = "shrine"
		wave_info.blessings = ["time_tick_level"]
	elif wave_info.wave_number % 10 == 0:
		wave_info.room_type = "shrine"
		wave_info.blessings = GlobalStats.get_two_random_curses()
	elif wave_info.wave_number % 2 == 1:
		if wave_info.wave_number % 10 < 5:
			# 1, 3
			wave_info.room_type = "combat"
			wave_info.enemies_to_spawn = 1 + current_wave	
		else:
			# 7, 9
			wave_info.room_type = "shrine"
			wave_info.blessings = GlobalStats.get_two_random_blessing()
	
	else:
		if wave_info.wave_number % 10 < 5:
			# 2, 4
			wave_info.room_type = "shrine"
			wave_info.blessings = GlobalStats.get_two_random_blessing()
		else:
			# 6, 8
			wave_info.room_type = "combat"
			wave_info.enemies_to_spawn = 1 + current_wave

	return wave_info