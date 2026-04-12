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
	"dash_distance": 0,
	"time_tick_level": 0,
	"enemy_speed" : 0,
	"enemy_health": 0,
	"heal" : 0,
	"damage" : 0,
	"enemy_damage" : 0,
	"player_attack_speed" : 0,
}
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

	total_stats["enemies_killed"] = 0
	total_stats["waves_completed"] = 0
	total_stats["total_time_survived"] = 0.0
	ordering = []

func add_to_stat(stat_name: String) -> void:
	if stat_name not in ordering:
		ordering.append(stat_name)

	if current_run_stats.has(stat_name):
		current_run_stats[stat_name] += 1
		if stat_name == "whale_level" and current_run_stats[stat_name] ==1:
			TutorialManager.show_tutorial(TutorialManager.TutorialEnum.FIRST_BELUGA)
		elif stat_name == "dash_distance" and current_run_stats[stat_name] ==1:
			TutorialManager.show_tutorial(TutorialManager.TutorialEnum.FIRST_DASH)

	else:
		print("Stat ", stat_name, " does not exist in current_run_stats.")
	
	hud.blessing_bar.sync_bar()


func get_heal_amount() -> int:
	return current_run_stats["heal"] * 7 + 7

func get_damage_amount() -> int:
	return current_run_stats["damage"] * 5 + 5

func get_attracted_radius() -> float:
	return 0.7 + current_run_stats["xp_suck"] * 0.4

func get_attracted_speed() -> float:
	return 0.3 + current_run_stats["xp_suck"] * 0.4

func get_enemy_xp_drop() -> int:
	return 1 + int(1.0 * current_run_stats["enemy_xp_drop"])

func get_enemy_damage() -> int:
	return 4 + current_run_stats["enemy_damage"] * 5

func get_dash_distance() -> float:
	return 5.0 + current_run_stats["dash_distance"] *3.0

func get_seconds_per_damage() -> float:
	## i want the damager per second to quadratically increase
	return 2.5/(1.0 + current_run_stats["time_tick_level"] * 0.5)**1.75
	# return 2.5/(1.0 + current_run_stats["time_tick_level"] * 0.25)


func get_enemy_speed_multiplier() -> float:
	return 1.0 + current_run_stats["enemy_speed"] * 0.3

func get_enemy_health_multiplier() -> float:
	return 1.0 + current_run_stats["enemy_health"] * 0.5

func get_whale_size() -> float:
	return current_run_stats["whale_level"] * 0.14

func get_attack_speed_multiplier() -> float:
	return 1.0 + current_run_stats["player_attack_speed"] * 0.2

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
