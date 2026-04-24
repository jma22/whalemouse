extends Node

signal stat_changed(stat_name: StringName, new_value: int)
signal boss_stat_changed(stat_name: StringName, new_value: int)
signal wave_augments_changed

var player :Node3D

var total_stats : Dictionary = {
	"enemies_killed": 0,
	"waves_completed": 0,
	"total_time_survived": 0.0
}

var current_run_stats : Dictionary = {
	
	# "enemy_xp_drop": 0,
	
	# "whale_damage": 0,
	# "dash_distance": 0,
	"time_tick_level": 0,
	# "enemy_speed" : 0,
	# "enemy_attack_speed" : 0,
	# "enemy_health": 0,
	"heal" : 0,
	"damage" : 0,
	# "enemy_damage" : 0,

	# "ebb_drop": 0,
	# "damaging_dash": 0,
	# "ebb_on_stand" : 0,
	
	# "damage_reduction" : 0,
	# "thornmail" : 0,
	# "fast_while_status" :0,
	# "flat_speed" : 0,
	


	"num_whales" : 0,
	"curse_on_hit" : 0,
	"extra_boss_health" : 0,
	"critical_chance" : 0,
	"boss_xp_drop" : 0,
	"boss_attack_size" : 0,
	"boss_freeze_time" : 0,

	"enemy_spawn_berserk": 0,
	"enemy_spawn_cursed": 0,
	"enemy_spawn_slippery": 0,
	"enemy_spawn_spikey": 0,
	"enemy_spawn_wither": 0,
	"enemy_spawn_poisoned": 0,
	"enemy_spawn_marked": 0,
	"enemy_spawn_shielded": 0,
	"enemy_spawn_infested": 0,
	"enemy_spawn_ebby": 0,

	"decay_on_damaged": 0,
	

	"dash_bomb" : 0,
	"bomber_whale": 0,
	"bomb_chain_reaction": 0,
	"bomb_size": 0,
	"bomb_tick_time": 0,
	"bomb_crit": 0,
	"bomb_orb_drop": 0,
	"poison_bombs": 0,

	"poison_beluga": 0,
	"poison_ebb_attack": 0,
	"poison_enemies_drop_bombs": 0,
	"poisoned_enemies_drop_ebbs": 0,
	"poison_kills_drop_orbs": 0,
	"faster_poison": 0,
	"slower_poison_more_lethal": 0,

	"marking_dash": 0,
	"marking_beluga": 0,
	"mark_makes_a_bomb": 0,
	"mark_to_orb": 0,
	"auto_consume_mark": 0,

	"player_attack_speed" : 0,
	"bigger_attack_every_n_hits" : 0,
	"player_attack_shrink" : 0,

	"movement_speed_up" : 0,
	"movement_slow_down" : 0,
	
	"dash_cooldown_reduction" : 0,
	"dash_cooldown_increase" : 0,
	"dash_distance_decrease" : 0,
	"suicide_dash" : 0,
	"dash_reset_on_damage" : 0,
	"special_killer_dash" : 0,

	"whale_size": 0,
	"whale_cooldown_reduction": 0,
	"on_beluga_kill_orb_drop": 0,
	"on_beluga_kill_cd_refund": 0,
	"on_beluga_kill_size_grow": 0,
	"beluga_whale_size_decrease": 0,
	"beluga_whale_cooldown_decrease": 0,
	"beluga_special_killer": 0,
	"beluga_auto_cast": 0,
	"beluga_freeze": 0,

	"deaths_dance": 0,
	"xp_suck" : 0,
	"speed_on_pickup": 0,
	"movement_speed_flat": 0,
	"ebb_begin_of_room": 0,
	"dying_ebb" :0,
	"midas_dash_touch": 0,
	"jump_kill_orb": 0,
	
	"has_beluga": 0,
	"has_dash": 0





	
	
}

var boss_stats : Dictionary = {
	"num_curses": 0,
	"num_blessings" : 0,
}
# var boss_stats : Dictionary = {
# 	"boss_health" : 0,
# 	"boss_damage" : 0,
# 	"boss_speed" : 0,
# 	"num_whales" : 0,
# }

var wave_augments :Dictionary = {}



var ordering : Array[String] = []

func setup(player_node : Node3D) -> void:
	player = player_node

func get_current_stats() -> Array[Dictionary]:
	var stats : Array[Dictionary] = []
	for stat_name in ordering:
		var stat_dict : Dictionary = {}
		stat_dict[stat_name] = current_run_stats[stat_name]
		stats.append(stat_dict)
	return stats

func add_kill() -> void:
	total_stats["enemies_killed"] += 1

func add_wave() -> void:
	total_stats["waves_completed"] += 1

func add_time_survived(time: float) -> void:
	total_stats["total_time_survived"] += time

func reset_current_run_stats() -> void:
	for k :String in current_run_stats.keys():
		current_run_stats[k] = 0

	for k : String in total_stats.keys():
		total_stats[k] = 0
	
	for k : String in boss_stats.keys():
		boss_stats[k] = 0
	
	ordering = []
	var override_dict : Dictionary = Config.get_override("starting_stats", {})
	for k : String in override_dict.keys():
		for i : int in range(override_dict[k]):	
			add_to_stat(k)
	
	var override_chosen_upgrades : Array = Config.get_override("chosen_upgrades", [])
	for upgrade_name : String in override_chosen_upgrades:
		UpgradeRegistry.get_by_name(upgrade_name).apply()

	var override_wave_augments : Dictionary = Config.get_override("starting_wave_augments", {})
	for k : String in override_wave_augments.keys():
		add_wave_augment(k, override_wave_augments[k])
	

func add_to_stat(stat_name: String) -> void:
	if stat_name not in ordering:
		ordering.append(stat_name)

	if current_run_stats.has(stat_name):
		current_run_stats[stat_name] += 1
		stat_changed.emit(stat_name, current_run_stats[stat_name])
	else:
		print("Stat ", stat_name, " does not exist in current_run_stats.")

func add_boss_stat(stat_name: String) -> void:
	if boss_stats.has(stat_name):
		boss_stats[stat_name] += 1
		boss_stat_changed.emit(stat_name, boss_stats[stat_name])

func add_wave_augment(augment_name: String, wave_duration : int) -> void:
	wave_augments[augment_name] = wave_duration
	wave_augments_changed.emit()

func decrement_wave_augments() -> void:
	var augments_to_remove : Array[String] = []
	for augment_name : String in wave_augments.keys():
		wave_augments[augment_name] -= 1
		if wave_augments[augment_name] <= 0:
			augments_to_remove.append(augment_name)
	for augment_name : String in augments_to_remove:
		wave_augments.erase(augment_name)
	wave_augments_changed.emit()
