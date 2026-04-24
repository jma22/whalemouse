extends Node3D

class_name WaveManager
var current_wave : int = 0
var combat_wave_number : int = 0
enum WaveState {
	INTRO_COMBAT,
	COMBAT,
	STACKABLE_BLESSING,
	FUNNY,
	CURSE,
	HARD_CURSE,
	ONETIME_BLESSING,
	QUEUED_WAVE,
	INTRO_BLESSING,
	BOSS_CHOICE,
	SOURCE
}
var wave_sequence : Array[WaveState] = [
	WaveState.INTRO_BLESSING,
	WaveState.INTRO_COMBAT,
	WaveState.FUNNY, 
	WaveState.COMBAT, 
	WaveState.CURSE, 
	#cycle
	WaveState.ONETIME_BLESSING,
	WaveState.INTRO_COMBAT,
	WaveState.FUNNY,
	WaveState.COMBAT,
	WaveState.HARD_CURSE,
	#cycle
	WaveState.SOURCE,
	WaveState.INTRO_COMBAT,
	WaveState.STACKABLE_BLESSING,
	WaveState.COMBAT,
	WaveState.CURSE,

	#cycle
	WaveState.ONETIME_BLESSING,
	WaveState.INTRO_COMBAT,
	WaveState.FUNNY,
	WaveState.COMBAT,
	WaveState.HARD_CURSE,
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
	print("Wave state: ", wave_state, " Wave info: ", current_wave_info)

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
	else:
		return wave_sequence[(current_wave) % wave_sequence.size()]

	
func _state_to_wave_info(state : WaveState) -> WaveInfo:
	match state:
		WaveState.COMBAT:
			return combat_wave()
		WaveState.STACKABLE_BLESSING:
			return stackable_blessing_wave()
		WaveState.CURSE:
			return curse_wave()
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
		WaveState.SOURCE:
			return source_wave()
		WaveState.ONETIME_BLESSING:
			return one_time_blessing_wave()
		WaveState.HARD_CURSE:
			return hard_curse_wave()

		
	printerr("Invalid wave state: ", state)
	return combat_wave() # default case, should never happen






func intro_blessing() -> ChoiceWaveInfo:
	if StatCalculator.has_dash() and StatCalculator.has_beluga():
		return one_time_blessing_wave()
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	var upgrades : Array[UpgradeData] = []
	if not StatCalculator.has_dash():
		upgrades.append(UpgradeRegistry.get_by_name("has_dash"))
	if not StatCalculator.has_beluga():
		upgrades.append(UpgradeRegistry.get_by_name("has_beluga"))
	wave_info.blessings.assign(upgrades)
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	wave_info.room_type = "shrine"

	wave_info.name = "A Helping Hand"
	return wave_info

func source_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	wave_info.blessings.assign(UpgradePicker.pick(UpgradePool.BLESSING, 2, [UpgradeTag.SOURCE]))
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	wave_info.room_type = "shrine"
	wave_info.name = "The Source"
	return wave_info


func one_time_blessing_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	wave_info.blessings.assign(UpgradePicker.pick(UpgradePool.BLESSING, 2, [UpgradeTag.ONETIME]))
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	wave_info.room_type = "shrine"
	wave_info.name = "Major Relics"
	return wave_info

	
func stackable_blessing_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	wave_info.blessings.assign(UpgradePicker.pick(UpgradePool.BLESSING, 2, [UpgradeTag.STACKABLE]))
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	wave_info.room_type = "shrine"
	wave_info.name = "Minor Relics"
	return wave_info


func hard_curse_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	var big_curse_data : UpgradeData = UpgradePicker.pick(UpgradePool.CURSE, 1, [UpgradeTag.BIG_CURSE])[0]
	var big_curse : Choice = big_curse_data.with_beluga_blessing()
	big_curse.override_blessing = false
	var second_curse_data : UpgradeData = UpgradePicker.pick(UpgradePool.CURSE, 1, [], [big_curse_data.internal_name])[0]
	var second_curse : Choice
	if second_curse_data.has_tag(UpgradeTag.BIG_CURSE):
		print("Applying beluga blessing to big curse: ", second_curse_data.internal_name)
		second_curse = second_curse_data.with_beluga_blessing()
		second_curse.override_blessing = false
	else:
		second_curse = second_curse_data.with_damage(8)
		second_curse.override_blessing = false
	wave_info.blessings.assign([big_curse, second_curse])
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	wave_info.room_type = "shrine"
	wave_info.name = "A Curse for You"
	return wave_info




func curse_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	var raw_upgrades : Array[UpgradeData] = UpgradePicker.pick(UpgradePool.CURSE, 2, [])
	var upgrades : Array[Choice] = []
	for upgrade : UpgradeData in raw_upgrades:
		print("Curse wave upgrade: ", upgrade.internal_name)
		print("Curse wave upgrade tags: ", upgrade.tags)
		if upgrade.has_tag(UpgradeTag.BIG_CURSE):
			print("Applying beluga blessing to big curse: ", upgrade.internal_name)
			var wrapped : Choice = upgrade.with_beluga_blessing()
			wrapped.override_blessing = false
			upgrades.append(wrapped)
		else:
			upgrades.append(upgrade)
	wave_info.blessings.assign(upgrades)
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	wave_info.room_type = "shrine"
	wave_info.name = "Curses"
	return wave_info

## FUNNY WAVES -------
func funny_wave() -> ChoiceWaveInfo:
	var name_to_wave_fn : Dictionary = {
		"bless_and_curse": choose_bless_and_curse_wave,
		"rerolls": reroll_wave.bind([] as Array[StringName], 1),
		"sustain": sustain_wave,
		# "shop": shop_wave,
		"shop_wave": shop_wave,
		# "whale_blessing": whale_blessing_wave,
		# "blessing" : two_blessing_wave,
		# "curse": curse_wave,
		# "hard_curse" : hard_curse_wave,
		"bless_or_heal": bless_or_heal_wave,  
		"curse_or_damage": curse_or_damage_wave,
		"intro": intro_blessing,
	}
	var wave_fn : Callable = name_to_wave_fn.values().pick_random()
	return wave_fn.call()

func sustain_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	var upgrades : Array[Choice] = []
	upgrades.assign(UpgradePicker.pick_or(UpgradePool.BLESSING, 2, [UpgradeTag.DROPS_ORBS, UpgradeTag.EBB_SOURCE]))
	var heal_choice : Choice = Choice.new(
		"Heal 10",
		func () -> String: return "Heal 10.").with_heal(10)
	upgrades.append(heal_choice)
	wave_info.blessings.assign(upgrades)
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	wave_info.room_type = "shrine"
	wave_info.name = "Sustaining Blessings"
	return wave_info

func shop_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	var upgrades : Array[Choice] = []
	for upgrade : UpgradeData in UpgradePicker.pick(UpgradePool.BLESSING, 3, []):
		if upgrade.has_tag(UpgradeTag.STACKABLE):
			upgrades.append(upgrade.with_damage(5))
		elif upgrade.has_tag(UpgradeTag.ONETIME):
			upgrades.append(upgrade.with_damage(10))
		else:
			upgrades.append(upgrade)

	var curse_data : UpgradeData = UpgradePicker.pick(UpgradePool.CURSE, 1, [])[0]
	var curse : Choice = curse_data.with_heal(10 if curse_data.has_tag(UpgradeTag.BIG_CURSE) else 5)
	curse.override_blessing = false
	upgrades.append(curse)
	wave_info.blessings.assign(upgrades)
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.SKIPPABLE
	wave_info.room_type = "shrine"
	wave_info.name = "The Bazaar"
	return wave_info

func choose_bless_and_curse_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	var choice_one : Choice = Choice.new(
		"Move on",
		func () -> String: return "Move on to the next wave.")
	var choice_two : Choice = Choice.new(
		"Blessing AND Curse",
		func () -> String: return "Take a blessing AND a curse.")
	choice_two.effects = [
		func() -> void: _queue_wave_effect(bless_and_curse_wave())
	]
	wave_info.blessings = [choice_one, choice_two]
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	wave_info.room_type = "shrine"
	wave_info.name = "A Strange Offer"
	return wave_info
	
func bless_and_curse_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	var upgrades : Array[Choice] = []
	upgrades.assign(UpgradePicker.pick(UpgradePool.BLESSING, 1, []))
	var curse_data : UpgradeData = UpgradePicker.pick(UpgradePool.CURSE, 1, [])[0]
	var curse : Choice = curse_data
	if curse_data.has_tag(UpgradeTag.BIG_CURSE):
		curse = curse_data.with_beluga_blessing()
		curse.override_blessing = false
	upgrades.append(curse)
	wave_info.blessings.assign(upgrades)
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ALL
	wave_info.room_type = "shrine"
	wave_info.name = "A Blessing AND A Curse"
	return wave_info


func reroll_wave(visited : Array[StringName], cost: int) -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	
	var choice_one : UpgradeData = UpgradePicker.pick(UpgradePool.BLESSING, 1, [], visited)[0]
	var choice_two : Choice = Choice.new(
		"Reroll",
		func () -> String: return "Spend %d health to reroll the relic." % cost)
	visited.append(choice_one.internal_name)
	choice_two.effects = [
		func() -> void: _queue_wave_effect(reroll_wave(visited, cost + 1))
	]
	choice_two = choice_two.with_damage(cost)
	wave_info.blessings = [choice_one, choice_two]
	wave_info.room_type = "shrine"
	wave_info.name = "Just one more roll"
	return wave_info


func bless_or_heal_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	var choice_one : Choice = Choice.new(
		"Blessing",
		func () -> String: return "Get a random blessing.")
	choice_one.effects = [_queue_wave_effect.bind(stackable_blessing_wave())]
	var choice_two : Choice = Choice.new(
		"Heal",
		func () -> String: return "Heal 10 HP.")
	choice_two = choice_two.with_heal(10)
	wave_info.blessings = [choice_one, choice_two]
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	wave_info.room_type = "shrine"
	wave_info.name = "A Kind Offer"
	return wave_info

func curse_or_damage_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	var choice_one : Choice = Choice.new(
		"Curse",
		func () -> String: return "Get a random curse.")
	choice_one.effects = [_queue_wave_effect.bind(curse_wave())]
	var choice_two : Choice = Choice.new(
		"Take Damage",
		func () -> String: return "Take 5 damage.")
	choice_two = choice_two.with_damage(5)
	wave_info.blessings = [choice_one, choice_two]
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	wave_info.room_type = "shrine"
	wave_info.name = "A Sinister Offer"
	return wave_info
## BOSS WAVES-------


func preboss_room() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	var choice_one : Choice = Choice.new(
		"Face the Angler",
		func () -> String: return "Fight the Angler.")
	choice_one.effects = [_queue_wave_effect.bind(boss_wave())]

	wave_info.blessings = [choice_one]
	wave_info.room_type = "shrine"
	wave_info.name = "An Encounter"
	return wave_info

func boss_choice_path() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	var boss_rooms : Array[Callable] = []
	for i in range(StatCalculator.get_num_boss_blessings()):
		boss_rooms.append(_queue_wave_effect.bind(boss_blessings_wave()))

	for i in range(StatCalculator.get_num_boss_curses()):
		boss_rooms.append(_queue_wave_effect.bind(boss_curse_wave()))
	boss_rooms.append(_queue_wave_effect.bind(preboss_room()))

	var choice_one : Choice = Choice.new(
		"Face the Curse",
		func () -> String:
			return "Prepare to for a powerful foe. You have %d blessings and %d curses." % [StatCalculator.get_num_boss_blessings(), StatCalculator.get_num_boss_curses()])
	choice_one.effects = boss_rooms
	var choice_two : Choice = Choice.new(
		"Skip the Boss",
		func () -> String: return "Go Deeper. Fight the boss later.")
	choice_two = choice_two.with_angler_curse()
	wave_info.blessings = [choice_one, choice_two]
	wave_info.room_type = "shrine"
	wave_info.name = "A Chance for an Encounter"
	return wave_info

func boss_blessings_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	wave_info.blessings.assign(UpgradePicker.pick(UpgradePool.BOSS_BLESSING, 2, []))
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	wave_info.room_type = "shrine"
	wave_info.name = "Beluga's Blessing"
	return wave_info

func boss_curse_wave() -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = current_wave
	wave_info.blessings.assign(UpgradePicker.pick(UpgradePool.BOSS_CURSE, 2, []))
	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
	wave_info.room_type = "shrine"
	wave_info.name = "Angler's Wrath"
	return wave_info

func boss_wave() -> BossWaveInfo:
	var wave_info : BossWaveInfo = BossWaveInfo.new()
	wave_info.wave_number = current_wave
	wave_info.boss_name = "Angler"
	wave_info.room_type = "boss"
	wave_info.name = "The Angler"
	return wave_info




## COMBAT WAVES --------

func combat_wave() -> CombatWaveInfo:
	var wave_info : CombatWaveInfo = CombatWaveInfo.new()
	wave_info.wave_number = current_wave
	wave_info.enemy_budget = (5 + combat_wave_number * 5) * (0 if Config.get_override("no_enemies") else 1)
	wave_info.enemy_pool = current_enemy_pool
	wave_info.room_type = "combat"
	wave_info.name = "Wave " + str(combat_wave_number+1)
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


func _queue_wave_effect(wave : WaveInfo) -> void:
	print("Queueing wave: ", wave.name)
	queued_wave_infos.append(wave)



# func two_random_blessings_wave() -> ChoiceWaveInfo:
# 	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
# 	wave_info.wave_number = current_wave
# 	var blessing_pool : Array[String] = ["blessing", "one_time_blessing", "whale_blessing"]
# 	wave_info.blessings.assign(Upgrades.get_randomized_upgrades(blessing_pool, 2))
# 	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ALL
# 	wave_info.room_type = "shrine"
# 	wave_info.name = "Twin Blessings"
# 	return wave_info


# func choice_path_wave() -> ChoiceWaveInfo:
# 	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
# 	wave_info.wave_number = current_wave
# 	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
# 	var choice_one : WaveChoice = WaveChoice.new(
# 		"Choice of curse",
# 		func () -> String:
# 			return "Get two random blessings, choose one curse.",
# 		[_queue_wave_effect.bind(two_random_blessings_wave()), _queue_wave_effect.bind(curse_wave())])
# 	var choice_two : WaveChoice = WaveChoice.new(
# 		"Choice of blessing",
# 		func () -> String:
# 			return "Get a random curse, choose two blessings.",
# 		[_queue_wave_effect.bind(force_random_curse_wave()), _queue_wave_effect.bind(two_blessing_wave()), _queue_wave_effect.bind(two_blessing_wave())])
# 	wave_info.blessings = [choice_one, choice_two]
# 	wave_info.room_type = "shrine"
# 	wave_info.name = "Illusion of Choice"
# 	return wave_info


# func bless_vs_curse_wave() -> ChoiceWaveInfo:
# 	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
# 	wave_info.wave_number = current_wave
# 	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
# 	var blessing_pool : Array[String] = ["blessing", "one_time_blessing", "whale_blessing"]
# 	var upgrade_pool : Array[UpgradeData] = Upgrades.get_randomized_augmented_upgrades(["curse","big_curse"], 1)
# 	upgrade_pool.append_array(Upgrades.get_randomized_augmented_upgrades(blessing_pool, 1))
# 	wave_info.blessings.assign(upgrade_pool)
# 	wave_info.room_type = "shrine"
# 	wave_info.name = "A Blessing or A Curse?"
# 	return wave_info


# func shop_wave() -> ChoiceWaveInfo:
# 	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
# 	wave_info.wave_number = current_wave
# 	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.SKIPPABLE
# 	var shop_pool : Array[String] = ["blessing", "curse", "one_time_blessing", "big_curse", "whale_blessing"]
# 	wave_info.blessings.assign(Upgrades.get_randomized_augmented_upgrades(shop_pool, 3))
# 	wave_info.room_type = "shrine"
# 	wave_info.name = "A Mysterious Shop"
# 	return wave_info


# func hard_curse_wave() -> ChoiceWaveInfo:
# 	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
# 	wave_info.wave_number = current_wave
# 	var curses : Array[UpgradeData] = Upgrades.get_randomized_upgrades(["big_curse"],1)
# 	var bonus_curses : Array[UpgradeData] = Upgrades.get_randomized_upgrades(["curse"], 1)
# 	curses.append(bonus_curses[0].with_harder_curse())
# 	wave_info.blessings.assign(curses)
# 	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
# 	wave_info.room_type = "shrine"
# 	wave_info.name = "Curse of the Depths"
# 	return wave_info

# func dash_wave() -> ChoiceWaveInfo:
# 	if StatCalculator.has_dash():
# 		return two_blessing_wave()
# 	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
# 	wave_info.wave_number = current_wave
# 	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
# 	var upgrade_one : UpgradeData = Upgrades.get_upgrade("dash_distance")

# 	wave_info.blessings = [upgrade_one,]
# 	wave_info.room_type = "shrine"
# 	wave_info.name = "The Dash"
# 	return wave_info


# func whale_blessing_wave() -> ChoiceWaveInfo:
# 	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
# 	wave_info.wave_number = current_wave
# 	wave_info.blessings.assign(Upgrades.get_randomized_upgrades(["whale_blessing"], 2))
# 	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
# 	wave_info.room_type = "shrine"
# 	wave_info.name = "Beluga's Aide"
# 	return wave_info


# func two_blessing_wave() -> ChoiceWaveInfo:
# 	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
# 	wave_info.wave_number = current_wave
# 	var blessing_pool : Array[String] = ["blessing", "one_time_blessing", "whale_blessing"]
# 	wave_info.blessings.assign(Upgrades.get_randomized_upgrades(blessing_pool, 2))
# 	wave_info.choice_type = ChoiceWaveInfo.ChoiceType.CHOOSE_ONE
# 	wave_info.room_type = "shrine"
# 	wave_info.name = "Two Blessings"
# 	return wave_info
