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

var currency_stats: Dictionary[StringName, int] = {
	GameConstants.SMALL_FRAGMENTS: 0,
	GameConstants.BOSS_FRAGMENTS: 0,
	GameConstants.CURSED_FRAGMENTS: 0,
}

var unlocked_memories: Array[String] = []
var unlocked_upgrades: Array[String] = []
signal on_currency_changed

func _ready() -> void:
	if Config.get_override("reset_gamedata"):
		_save()
	_load()
	_apply_overrides()

func _apply_overrides() -> void:
	for key: String in lifetime_stats:
		lifetime_stats[key] = Config.get_override("game_data/" + key, lifetime_stats[key])
	for currency: StringName in currency_stats:
		currency_stats[currency] = Config.get_override("game_data/currency/" + currency, currency_stats[currency])
	# for name: String in unlocked_upgrades:
	_evaluate_unlocks()
	# _save()
		
func is_unlocked(upgrade_name: String) -> bool:
	if Config.get_override("unlock_all", false):
		return true
	if Config.get_setting("user_unlock_all", false):
		return true
	return upgrade_name in unlocked_upgrades

func is_memory_unlocked(sticker_name: String) -> bool:
	if Config.get_override("unlock_all", false):
		return true
	if Config.get_setting("user_unlock_all", false):
		return true
	return sticker_name in unlocked_memories

func is_illustration_unlocked(unlockable: MemoryUnlockable) -> bool:
	return is_memory_unlocked(unlockable.to_string())

func record_run(run_stats: Dictionary, boss_defeated: bool) -> void:
	lifetime_stats["enemies_killed"] += run_stats.get("enemies_killed", 0)
	lifetime_stats["waves_completed"] += run_stats.get("waves_completed", 0)
	lifetime_stats["total_time_survived"] += run_stats.get("total_time_survived", 0.0)
	lifetime_stats["games_played"] += 1
	currency_stats[GameConstants.SMALL_FRAGMENTS] += run_stats.get("num_small_shards", 0)
	currency_stats[GameConstants.BOSS_FRAGMENTS] += run_stats.get("num_big_shards", 0)
	currency_stats[GameConstants.CURSED_FRAGMENTS] += run_stats.get("num_cursed_shards", 0)
	if boss_defeated:
		lifetime_stats["boss_defeats"] += 1
	var new_unlocks : Array[String] = _evaluate_unlocks()
	SceneManager.add_unlocks(new_unlocks)
	emit_signal("on_currency_changed")
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

func get_currency_amount() -> Dictionary[StringName, int]:
	return currency_stats.duplicate() # return a copy to prevent external modification

func spend_currency(cost: CostData) -> bool:
	if cost.can_afford():
		for cost_type: StringName in cost.dictionary.keys():
			currency_stats[cost_type] -= cost.dictionary[cost_type]
		emit_signal("on_currency_changed")
		DebugLog.dbg("GameData", "Spent currency: " + str(cost.dictionary) + " New amounts: " + str(currency_stats))
		_save()
		return true
	return false

func unlock_memory(sticker_name: String) -> bool:
	var memory_data : MemoryData = GameConstants.MEMORY_DATA.get(sticker_name, null)
	if memory_data == null:
		push_error("Invalid sticker name: " + sticker_name)
		return false
		# currency was successfully spent, unlock the memory
	unlocked_memories.append(sticker_name)
	unlocked_upgrades.append(memory_data.gated_upgrade)
	SceneManager.add_unlocks([memory_data.gated_upgrade])
	_save()
	return true

func unlock_unlockable(unlockable: MemoryUnlockable) -> bool:
	if unlockable == null:
		push_error("Invalid unlockable")
		return false
	unlocked_upgrades.append(unlockable.gated_upgrade)
	unlocked_memories.append(unlockable.to_string())
	SceneManager.add_unlocks([unlockable.gated_upgrade])
	_save()
	return true
	
func _save() -> void:
	var cfg := ConfigFile.new()
	for key: String in lifetime_stats:
		cfg.set_value("lifetime_stats", key, lifetime_stats[key])
	for name_: String in unlocked_upgrades:
		cfg.set_value("upgrade_unlocks", name_, true)
	for currency: StringName in currency_stats:
		cfg.set_value("currency", currency, currency_stats[currency])
	for sticker_name: String in unlocked_memories:
		cfg.set_value("memory_unlocks", sticker_name, true)
	cfg.save(SAVE_PATH)

func _load() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	if cfg.has_section("lifetime_stats"):
		for key: String in cfg.get_section_keys("lifetime_stats"):
			if lifetime_stats.has(key):
				lifetime_stats[key] = cfg.get_value("lifetime_stats", key)
	if cfg.has_section("upgrade_unlocks"):
		for name_: String in cfg.get_section_keys("upgrade_unlocks"):
			if cfg.get_value("upgrade_unlocks", name_, false):
				unlocked_upgrades.append(name_)
	if cfg.has_section("currency"):
		for currency_str: String in cfg.get_section_keys("currency"):
			currency_stats[StringName(currency_str)] = cfg.get_value("currency", currency_str, 0)
	if cfg.has_section("memory_unlocks"):
		for sticker_name: String in cfg.get_section_keys("memory_unlocks"):
			if cfg.get_value("memory_unlocks", sticker_name, false):
				unlocked_memories.append(sticker_name)
