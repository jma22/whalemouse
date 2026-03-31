extends Node


var total_stats = {
	"enemies_killed": 0,
	"waves_completed": 0,
	"total_time_survived": 0.0
}

var current_run_stats = {
	"xp_suck" : 0,
	"enemy_xp_drop": 0,
	"whale_level": 0,
	"dash_distance": 0,
	"time_tick_level": 0,
	"enemy_speed" : 0,
	"enemy_health": 0,
	"heal" : 0,
	"damage" : 0,
}

func reset_current_run_stats() -> void:
	current_run_stats["xp_suck"] = 0
	current_run_stats["enemy_xp_drop"] = 0
	current_run_stats["whale_level"] = 0
	current_run_stats["dash_distance"] = 0
	current_run_stats["time_tick_level"] = 0
	current_run_stats["enemy_speed"] = 0
	current_run_stats["enemy_health"] = 0
	current_run_stats["heal"] = 0
	current_run_stats["damage"] = 0

func add_to_stat(stat_name: String) -> void:
	if current_run_stats.has(stat_name):
		current_run_stats[stat_name] += 1
	else:
		print("Stat ", stat_name, " does not exist in current_run_stats.")

