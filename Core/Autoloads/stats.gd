extends Node

var player :Node3D
var hud : HUD

var total_stats : Dictionary = {
	"enemies_killed": 0,
	"waves_completed": 0,
	"total_time_survived": 0.0
}

var current_run_stats : Dictionary = {
	"xp_suck" : 0,
	"enemy_xp_drop": 0,
	"whale_level": 0,
	"whale_cooldown": 0,
	"whale_damage": 0,
	"dash_distance": 0,
	"time_tick_level": 0,
	"enemy_speed" : 0,
	"enemy_attack_speed" : 0,
	"enemy_health": 0,
	"heal" : 0,
	"damage" : 0,
	"enemy_damage" : 0,
	"player_attack_speed" : 0,
	"attack_size" : 0,
	"ebb_drop": 0,
	"damaging_dash": 0,
	"ebb_on_stand" : 0,
	"ebb_begin_of_room" : 0,
	"dying_ebb" :0,
	"damage_reduction" : 0,
	"thornmail" : 0,
	"fast_while_status" :0,
	"flat_speed" : 0,
	"dash_bomb" : 0,


	"num_whales" : 0,
	"curse_on_hit" : 0,
	"extra_boss_health" : 0,
	"critical_chance" : 0,
	"boss_xp_drop" : 0,
	"boss_attack_size" : 0,
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

func setup(player_node : Node3D, hud_node : HUD) -> void:
	player = player_node
	hud = hud_node

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

	var override_wave_augments : Dictionary = Config.get_override("starting_wave_augments", {})
	for k : String in override_wave_augments.keys():
		add_wave_augment(k, override_wave_augments[k])
	

func add_to_stat(stat_name: String) -> void:
	if stat_name not in ordering:
		ordering.append(stat_name)

	if current_run_stats.has(stat_name):
		current_run_stats[stat_name] += 1
		if stat_name == "whale_level" and current_run_stats[stat_name] ==1:
			TutorialManager.show_tutorial(TutorialManager.TutorialEnum.FIRST_BELUGA)
		elif stat_name == "dash_distance" and current_run_stats[stat_name] ==1:
			TutorialManager.show_tutorial(TutorialManager.TutorialEnum.FIRST_DASH)

	# elif boss_stats.has(stat_name):
	# 	boss_stats[stat_name] += 1
	else:
		print("Stat ", stat_name, " does not exist in current_run_stats.")
	if hud and hud.blessing_bar:
		hud.blessing_bar.sync_bar()

func add_boss_stat(stat_name: String) -> void:
	if boss_stats.has(stat_name):
		boss_stats[stat_name] += 1
	if hud and hud.boss_info:
		hud.boss_info.sync_bar()

func add_wave_augment(augment_name: String, wave_duration : int) -> void:
	wave_augments[augment_name] = wave_duration
	if hud and hud.blessing_bar:
		hud.blessing_bar.sync_bar()

func decrement_wave_augments() -> void:
	var augments_to_remove : Array[String] = []
	for augment_name : String in wave_augments.keys():
		wave_augments[augment_name] -= 1
		if wave_augments[augment_name] <= 0:
			augments_to_remove.append(augment_name)
	for augment_name : String in augments_to_remove:
		wave_augments.erase(augment_name)
	if hud and hud.blessing_bar:
		hud.blessing_bar.sync_bar()



func has_dash_bomb() -> bool:
	return current_run_stats["dash_bomb"] > 0
	
func get_whale_damage_flat() -> int:
	return current_run_stats["whale_damage"] + 1

func get_whale_cooldown() -> float:
	return current_run_stats["whale_cooldown"] * 0.1 ## 10 is 0 cooldown

func get_flat_speed() -> float:
	return current_run_stats["flat_speed"] * 0.25

func speed_during_status() -> int:
	return 0.5 + current_run_stats["fast_while_status"] * 0.3

func has_thorns() -> bool:
	return current_run_stats["thornmail"] > 0

func get_thorns_damage() -> int:
	return current_run_stats["thornmail"]
	
func get_damage_reduced_by() -> int:
	return 1 + current_run_stats["damage_reduction"]

func get_dying_ebb() -> int:
	if current_run_stats["dying_ebb"] > 0:
		return 6 + current_run_stats["dying_ebb"] * 3
	else:
		return 0
		
func get_ebb_begin_of_room() -> int:
	if current_run_stats["ebb_begin_of_room"] > 0:
		return 3 + current_run_stats["ebb_begin_of_room"]
	else:
		return 0

func get_ebb_on_stand() -> bool:
	return current_run_stats["ebb_on_stand"] > 0
	
func get_dash_damage() -> int:
	return current_run_stats["damaging_dash"]

func get_ebb_drop() -> int:
	return current_run_stats["ebb_drop"]

func get_mouse_attack_hitbox_scale() -> float:
	return 1.0 + current_run_stats["attack_size"] * 0.3

func get_heal_amount() -> int:
	return current_run_stats["heal"] * 5 + 4

func get_damage_amount() -> int:
	return current_run_stats["damage"] * 4 + 4

func get_attracted_radius() -> float:
	# return 0.7 + current_run_stats["xp_suck"] * 0.4
	return 0.4 + current_run_stats["xp_suck"] * 1.2

func get_attracted_speed() -> float:
	# return 0.3 + current_run_stats["xp_suck"] * 0.4
	return 0.15 + current_run_stats["xp_suck"] * 0.8

func get_bonus_enemy_xp_drop() -> int:
	return int(current_run_stats["enemy_xp_drop"])

func get_enemy_damage() -> int:
	return ceil(5 + current_run_stats["enemy_damage"] * 2.5)

func get_dash_distance() -> float:
	return 5.0 + current_run_stats["dash_distance"] *3.0

func get_seconds_per_damage() -> float:
	## i want the damager per second to quadratically increase
	return 2.5/(1.0 + current_run_stats["time_tick_level"] * 0.4)**1.3
	# return 2.5/(1.0 + current_run_stats["time_tick_level"] * 0.25)

func get_enemy_projectile_flat() -> int:
	var wave_augment_bonus : int = 1 if "enemy_attack_speed" in wave_augments else 0
	return current_run_stats["enemy_attack_speed"] + wave_augment_bonus

func get_enemy_attack_speed_multiplier() -> float:
	# var wave_augment_bonus : float = 1.0 if "enemy_attack_speed" in wave_augments else 0.0
	return 1.0 + current_run_stats["enemy_attack_speed"] * 0.2

func get_enemy_speed_multiplier() -> float:
	# var wave_augment_bonus : float = 0.3 if "enemy_speed" in wave_augments else 0.0
	return 1.0 + current_run_stats["enemy_speed"] * 0.25

func get_enemy_health_flat() -> float:
	return current_run_stats["enemy_health"]

func get_whale_size() -> float:
	return current_run_stats["whale_level"] * 0.14

func get_attack_speed_multiplier() -> float:
	return 1.0 + current_run_stats["player_attack_speed"] * 0.1

func has_beluga() -> bool:
	# return true
	return current_run_stats["whale_level"] > 0

func has_dash() -> bool:
	# return true
	return current_run_stats["dash_distance"] > 0

func is_positive_stat(stat_name: String) -> bool:
	if stat_name in ["xp_suck", "enemy_xp_drop", "whale_level", "dash_distance", "player_attack_speed"]:
		return true
	elif stat_name in ["time_tick_level", "enemy_speed", "enemy_health", "damage", "enemy_damage"]:
		return false
	else:
		return true



## boss zone
func get_num_boss_blessings() -> int:
	return boss_stats["num_blessings"]

func get_num_boss_curses() -> int:
	return boss_stats["num_curses"]

func get_healing_light_heal() -> int:
	return current_run_stats["time_tick_level"] * 15

func get_num_whales() -> int:
	return current_run_stats["num_whales"] + 1

func get_curse_duration_on_hit() -> float:
	return current_run_stats["curse_on_hit"] * 2.0

func get_extra_boss_health() -> int:
	return current_run_stats["extra_boss_health"] * 10

func get_critical_chance() -> float:
	return current_run_stats["critical_chance"] * 0.2

func get_boss_xp_drop_per_hit() -> int:
	return current_run_stats["boss_xp_drop"]

func get_boss_attack_size_multiplier() -> float:
	return 1.0 + current_run_stats["boss_attack_size"] * 0.5
