extends Object
class_name StatCalculator

static func has_dash_bomb() -> bool:
	return GlobalStats.current_run_stats["dash_bomb"] > 0

static func get_whale_damage_flat() -> int:
	return GlobalStats.current_run_stats["whale_damage"] + 1

static func get_whale_cooldown() -> float:
	return GlobalStats.current_run_stats["whale_cooldown"] * 0.1

static func get_flat_speed() -> float:
	return GlobalStats.current_run_stats["flat_speed"] * 0.25

static func speed_during_status() -> float:
	return 0.5 + GlobalStats.current_run_stats["fast_while_status"] * 0.3

static func has_thorns() -> bool:
	return GlobalStats.current_run_stats["thornmail"] > 0

static func get_thorns_damage() -> int:
	return GlobalStats.current_run_stats["thornmail"]

static func get_damage_reduced_by() -> int:
	return 1 + GlobalStats.current_run_stats["damage_reduction"]

static func get_dying_ebb() -> int:
	if GlobalStats.current_run_stats["dying_ebb"] > 0:
		return 6 + GlobalStats.current_run_stats["dying_ebb"] * 3
	return 0

static func get_ebb_begin_of_room() -> int:
	if GlobalStats.current_run_stats["ebb_begin_of_room"] > 0:
		return 3 + GlobalStats.current_run_stats["ebb_begin_of_room"]
	return 0

static func get_ebb_on_stand() -> bool:
	return GlobalStats.current_run_stats["ebb_on_stand"] > 0

static func get_dash_damage() -> int:
	return GlobalStats.current_run_stats["damaging_dash"]

static func get_ebb_drop() -> int:
	return GlobalStats.current_run_stats["ebb_drop"]

static func get_mouse_attack_hitbox_scale() -> float:
	return 1.0 + GlobalStats.current_run_stats["attack_size"] * 0.3

static func get_heal_amount() -> int:
	return GlobalStats.current_run_stats["heal"] * 5 + 4

static func get_damage_amount() -> int:
	return GlobalStats.current_run_stats["damage"] * 4 + 4

static func get_attracted_radius() -> float:
	return 0.4 + GlobalStats.current_run_stats["xp_suck"] * 1.2

static func get_attracted_speed() -> float:
	return 0.15 + GlobalStats.current_run_stats["xp_suck"] * 0.8

static func get_bonus_enemy_xp_drop() -> int:
	return int(GlobalStats.current_run_stats["enemy_xp_drop"])

static func get_enemy_damage() -> int:
	return ceil(5 + GlobalStats.current_run_stats["enemy_damage"] * 2.5)

static func get_dash_distance() -> float:
	return 5.0 + GlobalStats.current_run_stats["dash_distance"] * 3.0

static func get_seconds_per_damage() -> float:
	return 2.5 / (1.0 + GlobalStats.current_run_stats["time_tick_level"] * 0.4) ** 1.1

static func get_enemy_projectile_flat() -> int:
	var wave_augment_bonus: int = 1 if "enemy_attack_speed" in GlobalStats.wave_augments else 0
	return GlobalStats.current_run_stats["enemy_attack_speed"] + wave_augment_bonus

static func get_enemy_attack_speed_multiplier() -> float:
	return 1.0 + GlobalStats.current_run_stats["enemy_attack_speed"] * 0.2

static func get_enemy_speed_multiplier() -> float:
	return 1.0 + GlobalStats.current_run_stats["enemy_speed"] * 0.25

static func get_enemy_health_flat() -> float:
	return GlobalStats.current_run_stats["enemy_health"]

static func get_whale_size() -> float:
	return GlobalStats.current_run_stats["whale_level"] * 0.14

static func get_attack_speed_multiplier() -> float:
	return 1.0 + GlobalStats.current_run_stats["player_attack_speed"] * 0.1

static func has_beluga() -> bool:
	return GlobalStats.current_run_stats["whale_level"] > 0

static func has_dash() -> bool:
	return GlobalStats.current_run_stats["dash_distance"] > 0

static func is_positive_stat(stat_name: String) -> bool:
	if stat_name in ["xp_suck", "enemy_xp_drop", "whale_level", "dash_distance", "player_attack_speed"]:
		return true
	elif stat_name in ["time_tick_level", "enemy_speed", "enemy_health", "damage", "enemy_damage"]:
		return false
	return true


## boss zone
static func get_num_boss_blessings() -> int:
	return GlobalStats.boss_stats["num_blessings"]

static func get_num_boss_curses() -> int:
	return GlobalStats.boss_stats["num_curses"]

static func get_boss_freeze_time() -> int:
	return GlobalStats.current_run_stats["boss_freeze_time"] * 8

static func get_num_whales() -> int:
	return GlobalStats.current_run_stats["num_whales"] + 1

static func get_curse_duration_on_hit() -> float:
	return GlobalStats.current_run_stats["curse_on_hit"] * 2.0

static func get_extra_boss_health() -> int:
	return GlobalStats.current_run_stats["extra_boss_health"] * 10

static func get_critical_chance() -> float:
	return GlobalStats.current_run_stats["critical_chance"] * 0.2

static func get_boss_xp_drop_per_hit() -> int:
	return GlobalStats.current_run_stats["boss_xp_drop"]

static func get_boss_attack_size_multiplier() -> float:
	return 1.0 + GlobalStats.current_run_stats["boss_attack_size"] * 0.5

#enemy spawn zone

static func get_chance_for_effect(effect_name: String) -> float:
	if effect_name == "cursed":
		return get_chance_to_spawn_cursed()
	elif effect_name == "berserk":
		return get_chance_to_spawn_berserk()
	elif effect_name == "slippery":
		return get_chance_to_spawn_slippery()
	elif effect_name == "spikey":
		return get_chance_to_spawn_spikey()
	elif effect_name == "wither":
		return get_chance_to_spawn_wither()
	elif effect_name == "poison":
		return get_chance_to_spawn_poisoned()
	elif effect_name == "mark":
		return get_chance_to_spawn_marked()
	elif effect_name == "shielded":
		return get_chance_to_spawn_shielded()
	elif effect_name == "infested":
		return get_chance_to_spawn_infested()
	elif effect_name == "ebby":
		return get_chance_to_spawn_ebby()
	return 0.0

static func get_chance_to_spawn_ebby() -> float:
	return  GlobalStats.current_run_stats["enemy_spawn_ebby"] * 0.1
	
static func get_chance_to_spawn_infested() -> float:
	return  GlobalStats.current_run_stats["enemy_spawn_infested"] * 0.1

static func get_chance_to_spawn_cursed() -> float:
	return  GlobalStats.current_run_stats["enemy_spawn_cursed"] * 0.1

static func get_chance_to_spawn_berserk() -> float:
	return  GlobalStats.current_run_stats["enemy_spawn_berserk"] * 0.1

static func get_chance_to_spawn_slippery() -> float:
	return  GlobalStats.current_run_stats["enemy_spawn_slippery"] * 0.1

static func get_chance_to_spawn_spikey() -> float:
	return  GlobalStats.current_run_stats["enemy_spawn_spikey"] * 0.1

static func get_chance_to_spawn_wither() -> float:
	return  GlobalStats.current_run_stats["enemy_spawn_wither"] * 0.1

static func get_chance_to_spawn_poisoned() -> float:
	return  GlobalStats.current_run_stats["enemy_spawn_poisoned"] * 0.1

static func get_chance_to_spawn_marked() -> float:
	return  GlobalStats.current_run_stats["enemy_spawn_marked"] * 0.1

static func get_chance_to_spawn_shielded() -> float:
	return  GlobalStats.current_run_stats["enemy_spawn_shielded"] * 0.1
