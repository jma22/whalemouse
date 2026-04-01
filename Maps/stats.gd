extends Node


var player :Node3D
var hud : HUD

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
	ordering = []

func add_to_stat(stat_name: String) -> void:
	if stat_name not in ordering:
		ordering.append(stat_name)

	if current_run_stats.has(stat_name):
		current_run_stats[stat_name] += 1
		if stat_name == "heal":
			heal()
		if stat_name == "damage":
			damage()
	else:
		print("Stat ", stat_name, " does not exist in current_run_stats.")
	
	hud.blessing_bar.sync_bar()


func heal() -> void:
	var amount : int = current_run_stats["heal"] * 5
	player.heal(amount)

func damage() -> void:
	var amount : int = current_run_stats["damage"] * 3
	player.damage(amount)

func get_attracted_radius() -> float:
	return 0.75 + current_run_stats["xp_suck"] * 0.25

func get_attracted_speed() -> float:
	return 0.3 + current_run_stats["xp_suck"] * 0.25

func get_enemy_xp_drop() -> float:
	return 1.0 + current_run_stats["enemy_xp_drop"]

func get_dash_distance() -> float:
	return 5.0 + current_run_stats["dash_distance"] *1.5

func get_seconds_per_damage() -> float:
	## i want the damager per second to linearly increase
	return 2.0/(1.0 + current_run_stats["time_tick_level"] * 0.25)

func get_enemy_speed_multiplier() -> float:
	return 1.0 + current_run_stats["enemy_speed"] * 0.25

func get_enemy_health_multiplier() -> float:
	return 1.0 + current_run_stats["enemy_health"] * 0.5

func get_whale_size() -> float:
	return 0.5 + current_run_stats["whale_level"] * 0.25

func get_description(stat_name: String) -> String:
	match stat_name:
		"heal":
			return "%d more seconds." % ((1+current_run_stats["heal"]) * 5)
		"damage":
			return "%d less seconds." % ((1+current_run_stats["damage"]) * 3)
	return "lmao"
