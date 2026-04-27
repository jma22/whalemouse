extends Node

const SAVE_PATH := "user://game_data.cfg"
# cd Appdata/Roaming/Godot/app_userdata/


var lifetime_stats: Dictionary = {
	"enemies_killed": 0,
	"waves_completed": 0,
	"games_played": 0,
	"boss_defeats": 0,
	"total_time_survived": 0.0,
}

var unlocked_upgrades: Array[String] = []

func _ready() -> void:
	if Config.get_override("reset_gamedata"):
		_save()
	_load()
	_apply_overrides()

func _apply_overrides() -> void:
	for key: String in lifetime_stats:
		lifetime_stats[key] = Config.get_override("game_data/" + key, lifetime_stats[key])
	# for name: String in unlocked_upgrades:
	_evaluate_unlocks()
	# _save()
		
func is_unlocked(upgrade_name: String) -> bool:
	if Config.get_override("unlock_all", false):
		return true
	if Config.get_setting("user_unlock_all", false):
		return true
	return upgrade_name in unlocked_upgrades

func record_run(run_stats: Dictionary, boss_defeated: bool) -> void:
	lifetime_stats["enemies_killed"] += run_stats.get("enemies_killed", 0)
	lifetime_stats["waves_completed"] += run_stats.get("waves_completed", 0)
	lifetime_stats["total_time_survived"] += run_stats.get("total_time_survived", 0.0)
	lifetime_stats["games_played"] += 1
	if boss_defeated:
		lifetime_stats["boss_defeats"] += 1
	var new_unlocks : Array[String] = _evaluate_unlocks()
	SceneManager.add_unlocks(new_unlocks)
	_save()

func _evaluate_unlocks() -> Array[String]:
	var new_unlocks : Array[String] = []
	for upgrade: UpgradeData in UpgradeRegistry.all():
		if upgrade.unlock_condition.is_valid() and not is_unlocked(upgrade.internal_name):
			if upgrade.unlock_condition.call(lifetime_stats):
				new_unlocks.append(upgrade.internal_name)
				unlocked_upgrades.append(upgrade.internal_name)
	return new_unlocks

func get_stat(name_: String) -> Variant:
	return lifetime_stats[name_]

func _save() -> void:
	var cfg := ConfigFile.new()
	for key: String in lifetime_stats:
		cfg.set_value("lifetime_stats", key, lifetime_stats[key])
	for name: String in unlocked_upgrades:
		cfg.set_value("unlocks", name, true)
	cfg.save(SAVE_PATH)

func _load() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	if cfg.has_section("lifetime_stats"):
		for key: String in cfg.get_section_keys("lifetime_stats"):
			if lifetime_stats.has(key):
				lifetime_stats[key] = cfg.get_value("lifetime_stats", key)
	if cfg.has_section("unlocks"):
		for name: String in cfg.get_section_keys("unlocks"):
			if cfg.get_value("unlocks", name, false):
				unlocked_upgrades.append(name)
