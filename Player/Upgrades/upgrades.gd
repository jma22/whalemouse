extends Node
class_name Upgrades

static var list := {
	# "heal": UpgradeData.new("heal","Time on a Jar", "blessing", _heal_desc, [_increase_next_heal,_scaled_heal_effect]),
	# "xp_suck": UpgradeData.new("Orb Catcher", "blessing", _xp_suck_desc),
	# "enemy_xp_drop": UpgradeData.new("Feast Totem", "blessing", _enemy_xp_drop_desc),
	# "whale_level": UpgradeData.new("Beluga Plushie", "blessing", _whale_desc),
	# "dash_distance": UpgradeData.new("VROOM!!", "blessing", _dash_desc),
	# "time_tick_level": UpgradeData.new("Dark Algae", "curse", _time_tick_desc),
	# "damage": UpgradeData.new("Little Bite", "curse", _damage_desc),
	# "enemy_speed": UpgradeData.new("Flying Shell", "curse", _enemy_speed_desc),
	# "enemy_health": UpgradeData.new("Bulk Up", "curse", _enemy_health_desc),
	# "enemy_damage": UpgradeData.new("Poseidon's Fury", "curse", _enemy_damage_desc),
}


static func _static_init() -> void:
	_add_blessing("heal","Time on a Jar", _heal_desc, [_increase_next_heal,_scaled_heal_effect])







# --- public methods ---
static func get_upgrade(internal_name: String) -> UpgradeData:
	return list.get(internal_name, null)

# --- constructors ---
static func _add_blessing(internal_name: String, display_name: String, description_func: Callable, effects: Array[Callable] = []) -> void:
	var upgrade = UpgradeData.new(internal_name, display_name, "blessing", description_func, effects)
	list[internal_name] = upgrade

static func _add_curse(internal_name: String, display_name: String, description_func: Callable, effects: Array[Callable] = []) -> void:
	var upgrade = UpgradeData.new(internal_name, display_name, "curse", description_func, effects)
	list[internal_name] = upgrade	


# ---- effects ----
static func _flat_heal_effect(amount : int) -> void:
	# var amount : int = current_run_stats["heal"] * 7
	GlobalStats.player.heal(amount)

static func _scaled_heal_effect() -> void:
	var amount : int = GlobalStats.get_heal_amount()
	GlobalStats.player.heal(amount)

static func _increase_next_heal() -> void:
	GlobalStats.add_to_stat("heal")







# ------- DESCRIPTION FUNCTIONS -------
static func _heal_desc(level):
	return "Take some time! (+%d)" % ((1 + level) * 7)

static func _damage_desc(level):
	return "Too much time on your hands, take some damage! (-%d)" % ((1 + level) * 5)

static func _xp_suck_desc(_level):
	return "Orbs are more attracted to you!"

static func _enemy_xp_drop_desc(level):
	if level == 0:
		return "Enemies are more... nutritious?"
	else:
		return "Enemies give even more time!"

static func _whale_desc(level):
	if level == 0:
		return "Beluga is here to help!"
	else:
		return "Beluga grows bigger!"

static func _dash_desc(level):
	if level == 0:
		return "You can now dash!"
	return "Even more dashing!"

static func _time_tick_desc(_level):
	return "Time ticks faster..."

static func _enemy_speed_desc(_level):
	return "Enemies are faster!"

static func _enemy_health_desc(_level):
	return "Enemies are harder to kill!"

static func _enemy_damage_desc(_level):
	return "Enemies deal more damage!"
