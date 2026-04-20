extends Node
class_name Upgrades

static var list := {
}
static var augment_cost := {}

# static func _static_init() -> void:
# 	_add_generic_blessing("heal","Time on a Jar", _heal_desc, -3, [_scaled_heal_effect, _increase_stats_effect.bind("heal")])
# 	_add_one_time_blessing("xp_suck", "Orb Catcher", _xp_suck_desc, -4, [_increase_stats_effect.bind("xp_suck")])
# 	_add_generic_blessing("enemy_xp_drop", "Feast Totem", _enemy_xp_drop_desc, -10, [_increase_stats_effect.bind("enemy_xp_drop")])
# 	_add_whale_blessing("whale_level", "Beluga Plushie", _whale_desc, -3, [_increase_stats_effect.bind("whale_level")])
# 	_add_whale_blessing("whale_cooldown", "Beluga's Boon", _whale_cooldown_desc, -3, [_increase_stats_effect.bind("whale_cooldown")])
# 	_add_whale_blessing("whale_damage", "Beluga's Boon", _whale_damage_desc, -3, [_increase_stats_effect.bind("whale_damage")])
# 	_add_generic_blessing("dash_distance", "VROOM!!", _dash_desc, -5,[_increase_stats_effect.bind("dash_distance")])
# 	_add_big_curse("time_tick_level", "Dark Algae", _time_tick_desc, 15, [_increase_stats_effect.bind("time_tick_level")])
# 	_add_curse("damage", "Little Bite", _damage_desc, 2, [_scaled_damage_effect, _increase_stats_effect.bind("damage")])
# 	_add_curse("enemy_speed", "Flying Shell", _enemy_speed_desc, 3, [_increase_stats_effect.bind("enemy_speed")])
# 	_add_curse("enemy_attack_speed", "Flying Shell", _enemy_attack_speed_desc, 4, [_increase_stats_effect.bind("enemy_attack_speed")])
# 	_add_curse("enemy_health", "Bulk Up", _enemy_health_desc, 7, [_increase_stats_effect.bind("enemy_health")])
# 	_add_curse("enemy_damage", "Poseidon's Fury", _enemy_damage_desc, 6, [_increase_stats_effect.bind("enemy_damage")])
# 	_add_generic_blessing("attack_size", "Giant Clam", _attack_size_desc, -7, [_increase_stats_effect.bind("attack_size")])
# 	_add_generic_blessing("player_attack_speed", "Sonic Seashell", _attack_speed_desc, -8, [_increase_stats_effect.bind("player_attack_speed")])
# 	_add_generic_blessing("ebb_drop", "Ebb Essence", _ebb_drop_desc, -5, [_increase_stats_effect.bind("ebb_drop")])
# 	_add_one_time_blessing("ebb_on_stand", "Ebb's Embrace", _ebb_on_stand_desc, -6, [_increase_stats_effect.bind("ebb_on_stand")])
# 	_add_one_time_blessing("damaging_dash", "Shark Teeth", _damaging_dash_desc, -7,[_increase_stats_effect.bind("damaging_dash")])
# 	_add_generic_blessing("damage_reduction", "Big Shell", _damge_reduction_desc, -4,[_increase_stats_effect.bind("damage_reduction")])
# 	_add_one_time_blessing("thornmail", "Thornmail", _thornmail_desc, -8, [_increase_stats_effect.bind("thornmail")])
# 	_add_generic_blessing("fast_while_status", "Swift Current", _fast_during_status_desc, -4, [_increase_stats_effect.bind("fast_while_status")])
# 	_add_generic_blessing("flat_speed", "Streamlined Shell", _flat_speed_desc, -4, [_increase_stats_effect.bind("flat_speed")])
	

static func _static_init() -> void:
	_add_generic_blessing("heal","Time in a Jar", _heal_desc, -5, [_scaled_heal_effect, _increase_stats_effect.bind("heal")])
	_add_one_time_blessing("xp_suck", "Orb Catcher", _xp_suck_desc, -5, [_increase_stats_effect.bind("xp_suck")])
	_add_generic_blessing("enemy_xp_drop", "Feast Totem", _enemy_xp_drop_desc, -5, [_increase_stats_effect.bind("enemy_xp_drop")])
	_add_whale_blessing("whale_level", "Beluga Plushie", _whale_desc, -5, [_increase_stats_effect.bind("whale_level")])
	_add_whale_blessing("whale_cooldown", "Beluga Boon", _whale_cooldown_desc, -5, [_increase_stats_effect.bind("whale_cooldown")])
	_add_whale_blessing("whale_damage", "Beluga Fangs", _whale_damage_desc, -5, [_increase_stats_effect.bind("whale_damage")])
	_add_generic_blessing("dash_distance", "VROOM!!", _dash_desc, -5,[_increase_stats_effect.bind("dash_distance")])
	_add_big_curse("time_tick_level", "Dark Algae", _time_tick_desc, 10, [_increase_stats_effect.bind("time_tick_level")])
	_add_curse("damage", "Little Bite", _damage_desc, 10, [_scaled_damage_effect, _increase_stats_effect.bind("damage")])
	_add_curse("enemy_speed", "Flying Shell", _enemy_speed_desc, 10, [_increase_stats_effect.bind("enemy_speed")])
	_add_curse("enemy_attack_speed", "Piranha Fangs", _enemy_attack_speed_desc, 10, [_increase_stats_effect.bind("enemy_attack_speed")])
	_add_curse("enemy_health", "Bulk Up", _enemy_health_desc, 10, [_increase_stats_effect.bind("enemy_health")])
	_add_curse("enemy_damage", "Poseidon's Fury", _enemy_damage_desc, 10, [_increase_stats_effect.bind("enemy_damage")])
	_add_generic_blessing("attack_size", "Giant Potato", _attack_size_desc, -5, [_increase_stats_effect.bind("attack_size")])
	_add_generic_blessing("player_attack_speed", "Sonic Seashell", _attack_speed_desc, -5, [_increase_stats_effect.bind("player_attack_speed")])
	_add_generic_blessing("ebb_drop", "Ebb Essence", _ebb_drop_desc, -5, [_increase_stats_effect.bind("ebb_drop")])
	_add_one_time_blessing("ebb_on_stand", "Ebb's Embrace", _ebb_on_stand_desc, -5, [_increase_stats_effect.bind("ebb_on_stand")])
	_add_generic_blessing("dying_ebb", "Last Stand", _dying_ebb_desc, -5, [_increase_stats_effect.bind("dying_ebb")])
	_add_generic_blessing("damaging_dash", "Shark Teeth", _damaging_dash_desc, -5,[_increase_stats_effect.bind("damaging_dash")])
	_add_generic_blessing("damage_reduction", "Big Shell", _damge_reduction_desc, -5,[_increase_stats_effect.bind("damage_reduction")])
	_add_generic_blessing("thornmail", "Thornmail", _thornmail_desc, -5, [_increase_stats_effect.bind("thornmail")])
	_add_generic_blessing("fast_while_status", "Swift Current", _fast_during_status_desc, -5, [_increase_stats_effect.bind("fast_while_status")])
	_add_generic_blessing("flat_speed", "Eel boots?", _flat_speed_desc, -5, [_increase_stats_effect.bind("flat_speed")])

	_add_boss_curse("extra_boss_health", "Angler's Feast", _extra_boss_health_desc, [_increase_stats_effect.bind("extra_boss_health")])
	_add_boss_curse("curse_on_hit", "Poisonous Touch", _curse_on_hit_desc, [_increase_stats_effect.bind("curse_on_hit")])
	_add_boss_curse("boss_attack_size", "Massive Tentacles", _boss_attack_size_desc, [_increase_stats_effect.bind("boss_attack_size")])

	_add_boss_blessing("flat_heal", "Healing Light", _boss_heal_desc,  [_boss_heal_effect])
	_add_boss_blessing("num_whales", "Whale Song", _num_whales_desc,  [_increase_stats_effect.bind("num_whales")])
	_add_boss_blessing("boss_xp_drop", "Angler Hunter", _enemy_xp_drop_desc,  [_increase_stats_effect.bind("boss_xp_drop")])
	_add_boss_blessing("critical_chance", "Sharpshell", _critical_chance_desc,  [_increase_stats_effect.bind("critical_chance")])
	
	








# --- public methods ---
static func chosen_upgrade(upgrade_data : UpgradeData) -> void:
	if upgrade_data.blessing_type == "one_time_blessing":
		list.erase(upgrade_data.internal_name)
		augment_cost.erase(upgrade_data.internal_name)
		


static func get_upgrade(internal_name: String) -> UpgradeData:
	return list.get(internal_name, null)

static func get_randomized_augmented_upgrades(type: Array[String], amount: int) -> Array[UpgradeData]:
	var random_sample : Array[UpgradeData] = get_randomized_upgrades(type, amount)
	var augmented_sample : Array[UpgradeData] = []
	for upgrade in random_sample:
		augmented_sample.append(get_augmented_upgrade(upgrade))
	return augmented_sample


static func get_randomized_upgrades(type: Array[String], amount: int) -> Array[UpgradeData]:
	var randomized: Array[UpgradeData] = []

	# Collect only blessings or curses
	for upgrade : UpgradeData in list.values():
		if upgrade.blessing_type in type:
			randomized.append(upgrade)

	if randomized.size() < amount:
		return randomized
	
	randomized.shuffle()
	var chosen_upgrades : Array[UpgradeData] = randomized.slice(0, amount)
	for upgrade in chosen_upgrades:
		if upgrade.blessing_type == "big_curse":
			TutorialManager.show_tutorial(TutorialManager.TutorialEnum.BELUGAS_BLESSING)
			chosen_upgrades.append(get_beluga_upgrade(upgrade))
			chosen_upgrades.erase(upgrade)
		else:
			var rand_val : float = randf()
			if rand_val < 0.05:
				TutorialManager.show_tutorial(TutorialManager.TutorialEnum.BELUGAS_BLESSING)
				chosen_upgrades.append(get_beluga_upgrade(upgrade))
				chosen_upgrades.erase(upgrade)
			elif rand_val < 0.1:
				TutorialManager.show_tutorial(TutorialManager.TutorialEnum.ANGLERS_CURSE)
				chosen_upgrades.append(get_angler_upgrade(upgrade))
				chosen_upgrades.erase(upgrade)
	return chosen_upgrades

static func scale_augment_cost(flat : int)	-> int:
	var heal_scaling : float = 1.0
	var damage_scaling : float = 1.0
	var num : float = flat
	var seconds_scaling : float = 2
	if num < 0:
		## heal post curse
		num = abs(num) * (1  / GlobalStats.get_seconds_per_damage()) * seconds_scaling
		num *= heal_scaling
		num += randi_range(-3, 3)
	else:
		## damage post blessing
		num = abs(num) * (1  / GlobalStats.get_seconds_per_damage()) * seconds_scaling
		num *= damage_scaling
		num += randi_range(-2, 2)
	num = max(0, num)
	return floor(num)

static func scale_curse_damage(amount : int) -> int:
	# var damage_scaling : float = 0.5
	var seconds_scaling : float = 2
	var num : float = amount * (1  / GlobalStats.get_seconds_per_damage()) * seconds_scaling
	# num *= damage_scaling
	num += randi_range(-2, 2)
	num = max(0, num)
	return floor(num)

static func get_harder_curse(upgrade_data : UpgradeData) -> UpgradeData:
	var new_effects : Array[Callable] = upgrade_data.effects.duplicate()
	var augment_val : int = Upgrades.augment_cost.get(upgrade_data.internal_name, 0)
	var scaled_damage : int = scale_curse_damage(augment_val)
	new_effects.append(_flat_damage_effect.bind(scaled_damage))
	var new_desc : Callable = func new_description_func() -> String:
		return upgrade_data.get_description() + "\n[color=#FF0000]Lose " + str(scaled_damage) + "[/color]"
	var new_upgrade : UpgradeData = UpgradeData.new(
		upgrade_data.internal_name, 
		upgrade_data.display_name + "+", 
		upgrade_data.blessing_type, 
		new_desc,
		new_effects)
	return new_upgrade

static func get_augmented_upgrade(upgrade_data : UpgradeData) -> UpgradeData:
	var new_effects : Array[Callable] = upgrade_data.effects.duplicate()
	var augment_val : int = Upgrades.augment_cost.get(upgrade_data.internal_name, 0)
	var scaled_cost : int = scale_augment_cost(augment_val)
	var is_healing : bool = augment_val > 0
	if is_healing:
		new_effects.append(_flat_heal_effect.bind(scaled_cost))
	else:
		new_effects.append(_flat_damage_effect.bind(scaled_cost))
	var new_desc : Callable = func new_description_func() -> String:
		if augment_val < 0:
			return upgrade_data.get_description() + "\n[color=#FF0000]Lose " + str(scaled_cost) + "[/color]"
		elif augment_val > 0:
			return upgrade_data.get_description() + "\n[color=#00FF00]Heal " + str(scaled_cost) + "[/color]"
		else:
			return upgrade_data.get_description() 

	var new_display_name : String = upgrade_data.display_name + "+"
	var new_upgrade : UpgradeData = UpgradeData.new(
		upgrade_data.internal_name, 
		new_display_name, 
		upgrade_data.blessing_type, 
		new_desc,
		new_effects)
	return new_upgrade

static func get_beluga_upgrade(upgrade_data : UpgradeData) -> UpgradeData:
	var new_effects : Array[Callable] = upgrade_data.effects.duplicate()

	new_effects.append(_increase_boss_effect.bind("num_blessings"))

	var new_desc : Callable = func new_description_func() -> String:
		return upgrade_data.get_description() + "\n[rainbow freq=0.6 sat=0.8 val=1.0 speed=0.4]Beluga's Blessing[/rainbow]"
		

	var new_display_name : String = upgrade_data.display_name + "+"
	var new_upgrade : UpgradeData = UpgradeData.new(
		upgrade_data.internal_name, 
		new_display_name, 
		upgrade_data.blessing_type, 
		new_desc,
		new_effects)
	return new_upgrade

static func get_angler_upgrade(upgrade_data : UpgradeData) -> UpgradeData:
	var new_effects : Array[Callable] = upgrade_data.effects.duplicate()

	new_effects.append(_increase_boss_effect.bind("num_curses"))

	var new_desc : Callable = func new_description_func() -> String:
		return upgrade_data.get_description() + "\n[pulse freq=2.0 color=#3cb510FF ease=-3.0]Angler's Curse[/pulse]"
		

	var new_display_name : String = upgrade_data.display_name + "+"
	var new_upgrade : UpgradeData = UpgradeData.new(
		upgrade_data.internal_name, 
		new_display_name, 
		upgrade_data.blessing_type, 
		new_desc,
		new_effects)
	return new_upgrade

# --- constructors ---
static func _add_generic_blessing(internal_name: String, display_name: String, description_func: Callable, base_augment : int, effects: Array[Callable] = []) -> void:
	var upgrade : UpgradeData = UpgradeData.new(internal_name, display_name, "blessing", description_func, effects)
	list[internal_name] = upgrade
	augment_cost[internal_name] = base_augment

static func _add_whale_blessing(internal_name: String, display_name: String, description_func: Callable,  base_augment : int, effects: Array[Callable] = []) -> void:
	var upgrade : UpgradeData = UpgradeData.new(internal_name, display_name, "whale_blessing", description_func, effects)
	list[internal_name] = upgrade
	augment_cost[internal_name] = base_augment

static func _add_curse(internal_name: String, display_name: String, description_func: Callable, base_augment : int, effects: Array[Callable] = []) -> void:
	var upgrade : UpgradeData = UpgradeData.new(internal_name, display_name, "curse", description_func, effects)
	list[internal_name] = upgrade
	augment_cost[internal_name] = base_augment

static func _add_big_curse(internal_name: String, display_name: String, description_func: Callable,  base_augment : int, effects: Array[Callable] = []) -> void:
	var upgrade : UpgradeData = UpgradeData.new(internal_name, display_name, "big_curse", description_func, effects)
	list[internal_name] = upgrade
	augment_cost[internal_name] = base_augment

static func _add_one_time_blessing(internal_name: String, display_name: String, description_func: Callable, base_augment : int,effects: Array[Callable] = []) -> void:
	var upgrade : UpgradeData = UpgradeData.new(internal_name, display_name, "one_time_blessing", description_func, effects)
	list[internal_name] = upgrade
	augment_cost[internal_name] = base_augment

static func create_wave_choice_upgrade(internal_name: String, display_name: String, description_func: Callable, effects: Array[Callable] = []) -> UpgradeData:
	var upgrade : UpgradeData = UpgradeData.new(internal_name, display_name, "wave_choice_upgrade", description_func, effects)
	return upgrade

static func _add_boss_curse(internal_name: String, display_name: String, description_func: Callable, effects: Array[Callable] = []) -> void:
	var upgrade : UpgradeData = UpgradeData.new(internal_name, display_name, "boss_curse", description_func, effects)
	list[internal_name] = upgrade

static func _add_boss_blessing(internal_name: String, display_name: String, description_func: Callable, effects: Array[Callable] = []) -> void:
	var upgrade : UpgradeData = UpgradeData.new(internal_name, display_name, "boss_blessing", description_func, effects)
	list[internal_name] = upgrade

# ---- effects ----
static func _flat_heal_effect(amount : int) -> void:
	GlobalStats.player.heal(amount)

static func _boss_heal_effect() -> void:
	GlobalStats.player.heal(GlobalStats.get_healing_light_heal())

static func _scaled_heal_effect() -> void:
	var amount : int = GlobalStats.get_heal_amount()
	GlobalStats.player.heal(amount)

static func _flat_damage_effect(amount : int) -> void:
	GlobalStats.player.damage(amount)

static func _scaled_damage_effect() -> void:
	var amount : int = GlobalStats.get_damage_amount()
	GlobalStats.player.damage(amount)

static func _increase_stats_effect(stat_name: String) -> void:
	GlobalStats.add_to_stat(stat_name)

static func _increase_boss_effect(stat_name: String) -> void:
	GlobalStats.add_boss_stat(stat_name)




# ------- DESCRIPTION FUNCTIONS -------
static func _heal_desc() -> String:
	return "Take some time! Increase every time you choose it! (+%d)" % (GlobalStats.get_heal_amount())

static func _damage_desc() -> String:
	return "Lose some time! Increase every time you choose it! (-%d)" % (GlobalStats.get_damage_amount())

static func _xp_suck_desc() -> String:
	return "Orbs are attracted to you!"

static func _enemy_xp_drop_desc() -> String:
	if GlobalStats.current_run_stats["enemy_xp_drop"] == 0:
		return "Enemies have a chance to drop extra time orbs!"
	else:
		return "Enemies have a chance to drop even more time orbs!"

static func _whale_desc() -> String:
	if GlobalStats.current_run_stats["whale_level"] == 0:
		return "Call Beluga to attack enemies!"
	else:
		return "Beluga grows bigger!"

static func _whale_cooldown_desc() -> String:
	if GlobalStats.current_run_stats["whale_cooldown"] == 0:
		return "Beluga can attack more often!"
	else:
		return "Beluga's cooldown is even shorter!"

static func _whale_damage_desc() -> String:
	if GlobalStats.current_run_stats["whale_damage"] == 0:
		return "Beluga's attacks deal more damage!"
	else:
		return "Beluga's attacks deal even more damage!"

static func _dash_desc() -> String:
	if GlobalStats.current_run_stats["dash_distance"] == 0:
		return "You can now dash!"
	return "Even more dashing!"

static func _time_tick_desc() -> String:
	return "Time ticks faster..."

static func _enemy_speed_desc() -> String:
	return "Enemies move faster!"

static func _enemy_attack_speed_desc() -> String:
	return "Enemies attack come out faster!"

static func _enemy_health_desc() -> String:
	return "Enemies take one more hit to kill!"

static func _enemy_damage_desc() -> String:
	return "Enemy attacks deal more damage!"

static func _attack_size_desc() -> String:
	return "Your attacks hit a larger area!"

static func _attack_speed_desc() -> String:
	return "You can attack faster!"

static func _ebb_drop_desc() -> String:
	if GlobalStats.current_run_stats["ebb_drop"] == 0:
		return "Enemies have a chance to drop ebb orbs!"
	else:		
		return "Enemies have a chance to drop extra ebb orbs!"

static func _ebb_on_stand_desc() -> String:
	return "Gain ebb while standing still!"

static func _damaging_dash_desc() -> String:
	if GlobalStats.current_run_stats["dash_distance"] == 0:
		return "Your dash damages enemies! (You have no dash yet)"
	else:
		return "Your dash damages enemies!"

static func _damge_reduction_desc() -> String:
	return "Take less damage!" % (GlobalStats.get_damage_reduced_by())

static func _thornmail_desc() -> String:
	if GlobalStats.current_run_stats["thornmail"] == 0:
		return "Deal damage to enemies when you get hit!"
	else:
		return "Deal more damage to enemies when you get hit!" % (GlobalStats.get_thorns_damage())

static func _fast_during_status_desc() -> String:
	return "Move faster while affected by a status effect!"

static func _flat_speed_desc() -> String:
	return "Move faster!"

static func _dying_ebb_desc() -> String:
	return "Gain ebb when you are at low health!"


## boss zone

static func _boss_heal_desc() -> String:
	return "Heal %d" % (GlobalStats.get_healing_light_heal())

static func _curse_on_hit_desc() -> String:
	return "Bleed when you take damage."

static func _num_whales_desc() -> String:
	return "Summon an extra whale when you call Beluga!"

static func _extra_boss_health_desc() -> String:
	return "Increase boss health!"

static func _critical_chance_desc() -> String:
	return "Your attacks can critically strike for double damage!"

static func _boss_xp_drop_desc() -> String:
	return "Boss drops time orbs when damaged!"

static func _boss_attack_size_desc() -> String:
	return "Boss signature attack hits a larger area!"
