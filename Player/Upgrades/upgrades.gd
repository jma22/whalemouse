extends Node
class_name Upgrades

static var list := {
}
static var augment_cost := {}

static func _static_init() -> void:
	_add_generic_blessing("heal","Time on a Jar", _heal_desc, -3, [_scaled_heal_effect, _increase_stats_effect.bind("heal")])
	_add_generic_blessing("xp_suck", "Orb Catcher", _xp_suck_desc, -3, [_increase_stats_effect.bind("xp_suck")])
	_add_generic_blessing("enemy_xp_drop", "Feast Totem", _enemy_xp_drop_desc, -10, [_increase_stats_effect.bind("enemy_xp_drop")])
	_add_whale_blessing("whale_level", "Beluga Plushie", _whale_desc, [_increase_stats_effect.bind("whale_level")])
	_add_whale_blessing("whale_cooldown", "Beluga's Boon", _whale_cooldown_desc, [_increase_stats_effect.bind("whale_cooldown")])
	_add_whale_blessing("whale_damage", "Beluga's Boon", _whale_damage_desc, [_increase_stats_effect.bind("whale_damage")])
	_add_generic_blessing("dash_distance", "VROOM!!", _dash_desc, -5,[_increase_stats_effect.bind("dash_distance")])
	_add_big_curse("time_tick_level", "Dark Algae", _time_tick_desc, [_increase_stats_effect.bind("time_tick_level")])
	_add_curse("damage", "Little Bite", _damage_desc, 4, [_scaled_damage_effect, _increase_stats_effect.bind("damage")])
	_add_curse("enemy_speed", "Flying Shell", _enemy_speed_desc, 4, [_increase_stats_effect.bind("enemy_speed")])
	_add_curse("enemy_health", "Bulk Up", _enemy_health_desc, 7, [_increase_stats_effect.bind("enemy_health")])
	_add_curse("enemy_damage", "Poseidon's Fury", _enemy_damage_desc, 7, [_increase_stats_effect.bind("enemy_damage")])
	_add_generic_blessing("attack_size", "Giant Clam", _attack_size_desc, -7, [_increase_stats_effect.bind("attack_size")])
	_add_generic_blessing("player_attack_speed", "Sonic Seashell", _attack_speed_desc, -8, [_increase_stats_effect.bind("player_attack_speed")])
	_add_generic_blessing("ebb_drop", "Ebb Essence", _ebb_drop_desc, -5, [_increase_stats_effect.bind("ebb_drop")])
	_add_one_time_blessing("ebb_on_stand", "Ebb's Embrace", _ebb_on_stand_desc, -5, [_increase_stats_effect.bind("ebb_on_stand")])
	_add_one_time_blessing("damaging_dash", "Shark Teeth", _damaging_dash_desc, -7,[_increase_stats_effect.bind("damaging_dash")])
	_add_generic_blessing("damage_reduction", "Big Shell", _damge_reduction_desc, -4,[_increase_stats_effect.bind("damage_reduction")])
	_add_one_time_blessing("thornmail", "Thornmail", _thornmail_desc, -8, [_increase_stats_effect.bind("thornmail")])
	_add_generic_blessing("fast_while_status", "Swift Current", _fast_during_status_desc, -4, [_increase_stats_effect.bind("fast_while_status")])
	_add_generic_blessing("flat_speed", "Streamlined Shell", _flat_speed_desc, -4, [_increase_stats_effect.bind("flat_speed")])
	






# --- public methods ---
static func get_upgrade(internal_name: String) -> UpgradeData:
	return list.get(internal_name, null)

static func get_randomized_upgrades(type: Array[String], amount: int) -> Array[UpgradeData]:
	var randomized: Array[UpgradeData] = []

	# Collect only blessings or curses
	for upgrade : UpgradeData in list.values():
		if upgrade.blessing_type in type:
			randomized.append(upgrade)

	if randomized.size() < amount:
		return randomized

	randomized.shuffle()
	return randomized.slice(0, amount)

static func scale_augment_cost(flat : int)	-> int:
	var heal_scaling : float = 1.5
	var damage_scaling : float = 0.5
	var num : float = flat
	if num < 0:
		## heal post curse
		num = abs(num) * (1  / GlobalStats.get_seconds_per_damage()) + randi_range(-2, 2)
		num *= heal_scaling
		return floor(num)
	else:
		## damage post blessing
		num = num * GlobalStats.get_seconds_per_damage() + randi_range(-3, 3)
		num *= damage_scaling
		return floor(num)



static func get_augmented_upgrade(upgrade_data : UpgradeData) -> UpgradeData:
	var new_effects : Array[Callable] = upgrade_data.effects.duplicate()
	var augment_val : int = Upgrades.augment_cost.get(upgrade_data.internal_name, 0)
	var scaled_cost : int = scale_augment_cost(augment_val)
	new_effects.append(_flat_heal_effect.bind(scaled_cost))
	var new_desc : Callable = func new_description_func() -> String:
		if augment_val < 0:
			return upgrade_data.get_description() + "\nHeal " + str(scaled_cost)
		elif augment_val > 0:
			return upgrade_data.get_description() + "\nLose " + str(abs(scaled_cost))
		else:
			return upgrade_data.get_description() 

	var new_upgrade : UpgradeData = UpgradeData.new(
		upgrade_data.internal_name, 
		upgrade_data.display_name, 
		upgrade_data.blessing_type, 
		new_desc,
		new_effects)
	return new_upgrade


# --- constructors ---
static func _add_generic_blessing(internal_name: String, display_name: String, description_func: Callable, base_augment : int, effects: Array[Callable] = []) -> void:
	var upgrade : UpgradeData = UpgradeData.new(internal_name, display_name, "blessing", description_func, effects)
	list[internal_name] = upgrade
	augment_cost[internal_name] = base_augment

static func _add_whale_blessing(internal_name: String, display_name: String, description_func: Callable, effects: Array[Callable] = []) -> void:
	var upgrade : UpgradeData = UpgradeData.new(internal_name, display_name, "whale_blessing", description_func, effects)
	list[internal_name] = upgrade

static func _add_curse(internal_name: String, display_name: String, description_func: Callable, base_augment : int, effects: Array[Callable] = []) -> void:
	var upgrade : UpgradeData = UpgradeData.new(internal_name, display_name, "curse", description_func, effects)
	list[internal_name] = upgrade
	augment_cost[internal_name] = base_augment

static func _add_big_curse(internal_name: String, display_name: String, description_func: Callable, effects: Array[Callable] = []) -> void:
	var upgrade : UpgradeData = UpgradeData.new(internal_name, display_name, "big_curse", description_func, effects)
	list[internal_name] = upgrade

static func _add_one_time_blessing(internal_name: String, display_name: String, description_func: Callable, base_augment : int,effects: Array[Callable] = []) -> void:
	var upgrade : UpgradeData = UpgradeData.new(internal_name, display_name, "one_time_blessing", description_func, effects)
	list[internal_name] = upgrade
	augment_cost[internal_name] = base_augment

# ---- effects ----
static func _flat_heal_effect(amount : int) -> void:
	GlobalStats.player.heal(amount)

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





# ------- DESCRIPTION FUNCTIONS -------
static func _heal_desc() -> String:
	return "Take some time! (+%d)" % (GlobalStats.get_heal_amount())

static func _damage_desc() -> String:
	return "Lose some time! (-%d)" % (GlobalStats.get_damage_amount())

static func _xp_suck_desc() -> String:
	return "Orbs are more attracted to you!"

static func _enemy_xp_drop_desc() -> String:
	if GlobalStats.current_run_stats["enemy_xp_drop"] == 0:
		return "Enemies are more... nutritious?"
	else:
		return "Enemies give even more time!"

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
	return "Enemies are faster!"

static func _enemy_health_desc() -> String:
	return "Enemies are harder to kill!"

static func _enemy_damage_desc() -> String:
	return "Enemies deal more damage!"

static func _attack_size_desc() -> String:
	return "Your attacks hit a larger area!"

static func _attack_speed_desc() -> String:
	return "You can attack faster!"

static func _ebb_drop_desc() -> String:
	return "Enemies can drop ebb orbs!"

static func _ebb_on_stand_desc() -> String:
	return "Gain ebb while standing still!"

static func _damaging_dash_desc() -> String:
	return "Your dash damages enemies!"

static func _damge_reduction_desc() -> String:
	return "Take less damage!"

static func _thornmail_desc() -> String:
	return "Damage enemies when you get hit!"

static func _fast_during_status_desc() -> String:
	return "Move faster while affected by a status effect!"

static func _flat_speed_desc() -> String:
	return "Move faster!"