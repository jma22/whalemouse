extends Node3D

class_name WaveManager
var current_wave : int = 0

func reset() -> void:
	var starting_wave = Config.get_override("starting_wave", 0)
	current_wave = starting_wave	

func get_current_wave_info() -> WaveInfo:
	var wave_info : WaveInfo = WaveInfo.new()
	wave_info.wave_number = current_wave
	# every 2 and 4 waves are shrine waves
	# every 5 is a curse
	if wave_info.wave_number == 7:
		wave_info.room_type = "shrine"
		wave_info.blessings = ["whale_level"]
		wave_info.name = "Beluga's Blessing"
		return wave_info
	
	if wave_info.wave_number == 0:
		wave_info.room_type = "shrine"
		wave_info.blessings =  GlobalStats.get_two_random_blessing_no_whale()
		wave_info.name = "The Beginning"
		return wave_info

	if wave_info.wave_number % 10 == 0:
		wave_info.room_type = "shrine"
		wave_info.blessings = ["time_tick_level"]
		wave_info.name = "Curse of the Depths"
	elif wave_info.wave_number % 10 == 5:
		wave_info.room_type = "shrine"
		wave_info.blessings = GlobalStats.get_two_random_curses()
		wave_info.name = "Lesser Evils"
	elif wave_info.wave_number % 2 == 1:
		if wave_info.wave_number % 10 < 5:
			# 1, 3
			wave_info.room_type = "combat"
			var combat_wave_number = wave_number_to_combat_wave_number(wave_info.wave_number)
			wave_info.enemies_to_spawn = 1 + combat_wave_number
			wave_info.name = "Wave " + str(combat_wave_number)
			GlobalStats.add_wave()
		else:
			# 7, 9
			wave_info.room_type = "shrine"
			wave_info.blessings = GlobalStats.get_two_random_blessing()
			wave_info.name = "Blessings"
	
	else:
		if wave_info.wave_number % 10 < 5:
			# 2, 4
			wave_info.room_type = "shrine"
			if wave_info.wave_number < 7:
				wave_info.blessings = GlobalStats.get_two_random_blessing_no_whale()
			else:
				wave_info.blessings = GlobalStats.get_two_random_blessing()
			wave_info.name = "Blessings"
		else:
			# 6, 8
			wave_info.room_type = "combat"
			var combat_wave_number = wave_number_to_combat_wave_number(wave_info.wave_number)
			wave_info.enemies_to_spawn = 1 + combat_wave_number
			wave_info.name = "Wave " + str(combat_wave_number)
			GlobalStats.add_wave()

	return wave_info

func wave_number_to_combat_wave_number(wave_number: int) -> int:
	# 1,3,6,8,11,13,16,18,21,23 -> 1,2,3,4,5,6,7,8,9,10
	var n = int(wave_number / 5)
	if wave_number % 5 == 1:
		return n*2 + 1
	elif wave_number % 5 == 3:
		return n*2 + 2
	else:
		print("not right")
		return n*2
