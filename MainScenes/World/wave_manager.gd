extends Node3D

class_name WaveManager
var current_wave : int = 0
var combat_wave_number : int = 0
enum WaveState {
	INTRO_COMBAT,
	COMBAT,
	BLESSING,
	FUNNY,
	CURSE,
	HARD_CURSE,
	WHALE_BLESSING,
	QUEUED_WAVE,
	INTRO_BLESSING,
	BOSS_CHOICE,
}
var wave_sequence : Array[WaveState] = [
	WaveState.INTRO_COMBAT,
	WaveState.FUNNY, 
	WaveState.COMBAT, 
	WaveState.WHALE_BLESSING, 
	WaveState.HARD_CURSE, 
	WaveState.INTRO_COMBAT,
	WaveState.FUNNY,
	WaveState.COMBAT,
	WaveState.BLESSING,
	WaveState.CURSE,
	WaveState.BOSS_CHOICE,
	]

var current_enemy_pool : Array[String] = []
var queued_wave_infos : Array[WaveInfo] = []
var current_wave_state : WaveState = WaveState.INTRO_COMBAT


func reset() -> void:
	var starting_wave : int = Config.get_override("starting_wave", 0)
	current_wave = starting_wave
	combat_wave_number = 0
	current_enemy_pool = []
	queued_wave_infos = []
	current_wave_state = WaveState.INTRO_COMBAT

func exit_wave() -> void:
	## called before entering 
	if current_wave_state == WaveState.QUEUED_WAVE:
		var info : WaveInfo = queued_wave_infos.pop_front()
		if info.room_type == "boss":
			SceneManager.switch_to(SceneManager.SceneEnum.GAME_OVER)
		return
	

func enter_wave() -> WaveInfo:
	print("Entering wave ", current_wave)
	var wave_state : WaveState = _get_next_wave_state()
	current_wave_state = wave_state
	var current_wave_info : WaveInfo = _state_to_wave_info(wave_state)

	if wave_state == WaveState.QUEUED_WAVE:
		pass
	else:
		current_wave += 1
		if wave_state == WaveState.COMBAT:
			combat_wave_number += 1
			GlobalStats.add_wave()

	return current_wave_info

func _get_next_wave_state() -> WaveState:
	if queued_wave_infos.size() > 0:
		return WaveState.QUEUED_WAVE
	if current_wave == 0:
		return WaveState.INTRO_BLESSING
	else:
		return wave_sequence[(current_wave- 1) % wave_sequence.size()]

	
func _state_to_wave_info(state : WaveState) -> WaveInfo:
	match state:
		WaveState.COMBAT:
			return combat_wave()
		WaveState.BLESSING:
			return two_blessing_wave()
		WaveState.CURSE:
			return curse_wave()
		WaveState.HARD_CURSE:
			return hard_curse_wave()
		WaveState.WHALE_BLESSING:
			return whale_blessing_wave()
		WaveState.FUNNY:
			return funny_wave()
		WaveState.INTRO_COMBAT:
			return intro_combat_wave()
		WaveState.INTRO_BLESSING:
			return intro_blessing()
		WaveState.QUEUED_WAVE:
			return queued_wave_infos[0]
		WaveState.BOSS_CHOICE:
			return boss_choice_path()

		
	printerr("Invalid wave state: ", state)
	return combat_wave() # default case, should never happen

func funny_wave() -> ChoiceWaveInfo:
	var name_to_wave_fn : Dictionary = {
		"bless_vs_curse": bless_vs_curse_wave,
		"shop": shop_wave,
		"choose_path": choice_path_wave,
		"whale_blessing": whale_blessing_wave,
	}
	var wave_fn : Callable = name_to_wave_fn.values().pick_random()
	return wave_fn.call()


func preboss_room() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	var upgrade_one : UpgradeData = Upgrades.create_wave_choice_upgrade(
		"boss_angler", 
		"Face the Angler", 
		func () -> String:
			return "Fight the Angler.",
		[_queue_wave_effect.bind(boss_wave())])
	
	wave_info.blessings = [upgrade_one]
	wave_info.room_type = "shrine"
	wave_info.name = "An Encounter"
	return wave_info

func boss_choice_path() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	var boss_rooms : Array[Callable] = []
	for i in range(GlobalStats.get_num_boss_blessings()):
		boss_rooms.append(_queue_wave_effect.bind(boss_blessings_wave()))

	for i in range(GlobalStats.get_num_boss_curses()):
		boss_rooms.append(_queue_wave_effect.bind(boss_curse_wave()))
	boss_rooms.append(_queue_wave_effect.bind(preboss_room()))

	var upgrade_one : UpgradeData = Upgrades.create_wave_choice_upgrade(
		"boss_angler", 
		"Face the Curse", 
		func () -> String:
			return "Prepare to for a powerful foe. You have %d blessings and %d curses." % [GlobalStats.get_num_boss_blessings(), GlobalStats.get_num_boss_curses()],
		boss_rooms)
	var upgrade_two : UpgradeData = Upgrades.create_wave_choice_upgrade(
		"skip_boss", 
		"Skip the Boss",
		func () -> String:
			return "Go Deeper. Fight the boss later.",
		[])
	wave_info.blessings = [upgrade_one, upgrade_two]
	wave_info.room_type = "shrine"
	wave_info.name = "A Chance for an Encounter"
	return wave_info



func choice_path_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	var upgrade_one : UpgradeData = Upgrades.create_wave_choice_upgrade(
		"random_bless_choose_curse", 
		"Choice of curse", 
		func () -> String:
			return "Get two random blessings, choose one curse.",
		[_queue_wave_effect.bind(two_random_blessings_wave()), _queue_wave_effect.bind(curse_wave())])
	var upgrade_two : UpgradeData = Upgrades.create_wave_choice_upgrade(
		"random_curse_choose_bless",
		"Choice of blessing",
		func () -> String:
			return "Get a random curse, choose two blessings.",
		[_queue_wave_effect.bind(force_random_curse_wave()), _queue_wave_effect.bind(two_blessing_wave()), _queue_wave_effect.bind(two_blessing_wave())])
	wave_info.blessings = [upgrade_one, upgrade_two]
	wave_info.room_type = "shrine"
	wave_info.name = "Illusion of Choice"
	return wave_info

func boss_blessings_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	var blessing_pool : Array[String] = ["boss_blessing"]
	wave_info.blessings = Upgrades.get_randomized_upgrades(blessing_pool, 2)
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	wave_info.room_type = "shrine"
	wave_info.name = "Beluga's Blessing"
	return wave_info

func boss_curse_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	var blessing_pool : Array[String] = ["boss_curse"]
	wave_info.blessings = Upgrades.get_randomized_upgrades(blessing_pool, 2)
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	wave_info.room_type = "shrine"
	wave_info.name = "Angler's Wrath"
	return wave_info
	
	

func two_random_blessings_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	var blessing_pool : Array[String] = ["blessing"]
	if GlobalStats.has_beluga():
		blessing_pool.append("whale_blessing")
	wave_info.blessings = Upgrades.get_randomized_upgrades(blessing_pool, 2)
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ALL
	wave_info.room_type = "shrine"
	wave_info.name = "Twin Blessings"
	return wave_info

func force_random_curse_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	wave_info.blessings = Upgrades.get_randomized_upgrades(["curse"], 1)
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ALL
	wave_info.room_type = "shrine"
	wave_info.name = "A Curse for You"
	return wave_info


func bless_vs_curse_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	var blessing_pool : Array[String] = ["blessing"]
	var upgrade_pool : Array[UpgradeData] = Upgrades.get_randomized_augmented_upgrades(["curse"], 1)
	if GlobalStats.has_beluga():
		blessing_pool.append("whale_blessing")
	
	upgrade_pool.append_array(Upgrades.get_randomized_augmented_upgrades(blessing_pool, 1))
	wave_info.blessings = upgrade_pool
	wave_info.room_type = "shrine"
	wave_info.name = "A Blessing or A Curse?"
	return wave_info


func shop_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.SKIPPABLE
	var shop_pool : Array[String] = ["blessing","curse", "one_time_blessing","big_curse"]
	if GlobalStats.has_beluga():
		shop_pool.append("whale_blessing")
	wave_info.blessings = Upgrades.get_randomized_augmented_upgrades(shop_pool, 3)
	wave_info.room_type = "shrine"
	wave_info.name = "A Mysterious Shop"
	return wave_info


func hard_curse_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	var curses : Array[UpgradeData] = Upgrades.get_randomized_upgrades(["big_curse"],1)
	var bonus_curses : Array[UpgradeData] = Upgrades.get_randomized_upgrades(["curse"], 1)
	curses.append(Upgrades.get_harder_curse(bonus_curses[0]))
	wave_info.blessings = curses
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	wave_info.room_type = "shrine"
	wave_info.name = "Curse of the Depths"
	return wave_info

func curse_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	wave_info.blessings = Upgrades.get_randomized_upgrades(["curse"], 2)
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	wave_info.room_type = "shrine"
	wave_info.name = "Curses"
	return wave_info


func whale_blessing_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	if GlobalStats.has_beluga():
		wave_info.blessings = Upgrades.get_randomized_upgrades(["whale_blessing"], 2)
	else:
		wave_info.blessings = [Upgrades.get_upgrade("whale_level")]
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	wave_info.room_type = "shrine"
	wave_info.name = "Beluga's Blessing"
	return wave_info

func intro_blessing() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = two_blessing_wave()
	wave_info.name = "The Beginning"
	return wave_info

func combat_wave() -> CombatWaveInfo:
	var wave_info : CombatWaveInfo = CombatWaveInfo.new()
	wave_info.wave_number = current_wave
	wave_info.enemy_budget = (5 + combat_wave_number * 5) * (0 if Config.get_override("no_enemies") else 1)
	wave_info.enemy_pool = current_enemy_pool
	wave_info.room_type = "combat"
	wave_info.name = "Wave " + str(combat_wave_number+1)
	return wave_info

func boss_wave() -> BossWaveInfo:
	var wave_info : BossWaveInfo = BossWaveInfo.new()
	wave_info.wave_number = current_wave
	wave_info.boss_name = "Angler"
	wave_info.room_type = "boss"
	wave_info.name = "The Angler"
	return wave_info



func intro_combat_wave() -> CombatWaveInfo:
	var new_enemy : String = EnemySpawner.sample_unlockable_enemy(current_wave, current_enemy_pool)
	if new_enemy == "":
		return combat_wave()
	else:
		current_enemy_pool.append(new_enemy)
		var wave_info : CombatWaveInfo = CombatWaveInfo.new()
		wave_info.wave_number = current_wave
		wave_info.enemy_budget = EnemySpawner.get_enemy_data(new_enemy).cost * 3 * (0 if Config.get_override("no_enemies") else 1)
		wave_info.enemy_pool = [new_enemy]
		wave_info.room_type = "combat"
		wave_info.name = EnemySpawner.get_enemy_data(new_enemy).name + " Cove"
		return wave_info

func two_blessing_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	var blessing_pool : Array[String] = ["blessing"]
	if GlobalStats.has_beluga():
		blessing_pool.append("whale_blessing")
	wave_info.blessings = Upgrades.get_randomized_upgrades(blessing_pool, 2)
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	wave_info.room_type = "shrine"
	wave_info.name = "Two Blessings"
	return wave_info


func _queue_wave_effect(wave : WaveInfo) -> void:
	print("Queueing wave: ", wave.name)
	queued_wave_infos.append(wave)
# intro blessing

# fight
# blessing_cool
# fight
# whale_blessing
# curse
# fight
# blessing_cool
# fight
# blessing
# fight
# whale_blessing
# big_curse




# func get_current_wave_info() -> WaveInfo:
# 	var wave_info : WaveInfo = WaveInfo.new()
# 	wave_info.wave_number = current_wave
# 	# every 2 and 4 waves are shrine waves
# 	# every 5 is a curse

# 	# if wave_info.wave_number == 69:
# 	# 	wave_info.enemies_to_spawn = 1
# 	# 	wave_info.room_type = "boss"
# 	# 	wave_info.boss_name = "SquidBoss"
# 	# 	wave_info.name = "The Final Showdown"
# 	# 	return wave_info

# 	if wave_info.wave_number == 7:
# 		wave_info.room_type = "shrine"
# 		wave_info.blessings = [Upgrades.get_upgrade("whale_level")]
# 		wave_info.name = "Beluga's Blessing"
# 		return wave_info
	
# 	if wave_info.wave_number == 0:
# 		wave_info.room_type = "shrine"
# 		wave_info.blessings =  Upgrades.get_randomized_upgrades(["blessing"], 2)
# 		wave_info.name = "The Beginning"
# 		return wave_info

# 	if wave_info.wave_number % 10 == 0:
# 		wave_info.room_type = "shrine"
# 		wave_info.blessings = [Upgrades.get_upgrade("time_tick_level")]
# 		wave_info.name = "Curse of the Depths"
# 	elif wave_info.wave_number % 10 == 5:
# 		wave_info.room_type = "shrine"
# 		wave_info.blessings = Upgrades.get_randomized_upgrades(["curse"], 2)
# 		wave_info.name = "Lesser Evils"
# 	elif wave_info.wave_number % 2 == 1:
# 		if wave_info.wave_number % 10 < 5:
# 			# 1, 3
# 			wave_info.room_type = "combat"
# 			var combat_wave_number : int = wave_number_to_combat_wave_number(wave_info.wave_number)
# 			wave_info.enemies_to_spawn = 1 + combat_wave_number
# 			wave_info.name = "Wave " + str(combat_wave_number)
# 			GlobalStats.add_wave()
# 		else:
# 			# 7, 9
# 			wave_info.room_type = "shrine"
# 			wave_info.blessings = Upgrades.get_randomized_upgrades(["blessing", "whale_blessing"], 2)
# 			wave_info.name = "Blessings"
	
# 	else:
# 		if wave_info.wave_number % 10 < 5:
# 			# 2, 4
# 			wave_info.room_type = "shrine"
# 			if wave_info.wave_number < 7:
# 				wave_info.blessings = Upgrades.get_randomized_upgrades(["blessing"], 2)
# 			else:
# 				wave_info.blessings = Upgrades.get_randomized_upgrades(["blessing", "whale_blessing"], 2)
# 			wave_info.name = "Blessings"
# 		else:
# 			# 6, 8
# 			wave_info.room_type = "combat"
# 			var combat_wave_number : int = wave_number_to_combat_wave_number(wave_info.wave_number)
# 			wave_info.enemies_to_spawn = 1 + combat_wave_number
# 			wave_info.name = "Wave " + str(combat_wave_number)
# 			GlobalStats.add_wave()

# 	return wave_info

# func wave_number_to_combat_wave_number(wave_number: int) -> int:
# 	# 1,3,6,8,11,13,16,18,21,23 -> 1,2,3,4,5,6,7,8,9,10
# 	var n : int = int(wave_number / 5)
# 	if wave_number % 5 == 1:
# 		return n*2 + 1
# 	elif wave_number % 5 == 3:
# 		return n*2 + 2
# 	else:
# 		print("not right")
# 		return n*2
