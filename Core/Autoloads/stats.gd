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
	for k in current_run_stats.keys():
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
		elif stat_name == "heal":
			heal()
		elif stat_name == "damage":
			damage()
	else:
		print("Stat ", stat_name, " does not exist in current_run_stats.")
	
	hud.blessing_bar.sync_bar()


func heal() -> void:
	var amount : int = current_run_stats["heal"] * 7
	player.heal(amount)

func damage() -> void:
	var amount : int = current_run_stats["damage"] * 5
	player.damage(amount)

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

func get_description(stat_name: String) -> String:
	match stat_name:
		"heal":
			return "Take some time! And more later! (+%d)" % ((1+current_run_stats["heal"]) * 7)
		"damage":
			return "Too much time on your hands... (-%d)" % ((1+current_run_stats["damage"]) * 5)
		"xp_suck":
			return "Even orbs are attracted to you!"
		"enemy_xp_drop":
			return "Enemies are more... nutritious?"
		"whale_level":
			if current_run_stats["whale_level"] == 0:
				return "Beluga is here to help!"
			return "Beluga grows bigger!"
		"dash_distance":
			return "You go vroom!"
		"time_tick_level":
			return "Time ticks faster..."
		"enemy_speed":
			return "Enemies go vroom!"
		"enemy_health":
			return "Enemies gain weight..."	
		"enemy_damage":
			return "Enemies grow spikes..."
	return "lmao"

func get_two_random_blessing() -> Array[String]:
	var blessings : Array[String] = ["xp_suck", "enemy_xp_drop", "whale_level", "dash_distance","heal"]
	var selected : Array[String] = []
	while selected.size() < 2 and blessings.size() > 0:
		var index = randi() % blessings.size()
		selected.append(blessings[index])
		blessings.remove_at(index)
	return selected

func get_two_random_curses() -> Array[String]:
	var curses : Array[String] = ["enemy_speed", "enemy_health", "damage", "enemy_damage"]
	var selected : Array[String] = []
	while selected.size() < 2 and curses.size() > 0:
		var index = randi() % curses.size()
		selected.append(curses[index])
		curses.remove_at(index)
	return selected

func get_two_random_blessing_no_whale() -> Array[String]:
	var blessings : Array[String] = ["xp_suck", "enemy_xp_drop", "dash_distance","heal"]
	var selected : Array[String] = []
	while selected.size() < 2 and blessings.size() > 0:
		var index = randi() % blessings.size()
		selected.append(blessings[index])
		blessings.remove_at(index)
	return selected

func is_blessing(stat_name: String) -> bool:
	return stat_name in ["xp_suck", "enemy_xp_drop", "whale_level", "dash_distance","heal"]

func has_beluga() -> bool:
	# return true
	return current_run_stats["whale_level"] > 0

func has_dash() -> bool:
	# return true
	return current_run_stats["dash_distance"] > 0
