extends Object
class_name StatCalculator


### NEWS
static func get_player_max_health() -> int:
	var base_health:int = 30
	match Config.get_difficulty():
		Config.Difficulty.EASY:
			base_health = 40
		Config.Difficulty.NORMAL:
			base_health = 30
		Config.Difficulty.HARD:
			base_health = 20
	return base_health + GlobalStats.current_run_stats["player_max_health"] * 5

static func get_movement_speed_flat() -> float:
	return GlobalStats.current_run_stats["movement_speed_flat"] * 0.5

static func has_death_dance() -> bool:
	return GlobalStats.current_run_stats["deaths_dance"] > 0

static func get_flow_stacks_per_pickup() -> int:
	return GlobalStats.current_run_stats["speed_on_pickup"]

static func orbs_on_beluga_kill(preview: bool = false) -> int:
	var stat_level: int = GlobalStats.current_run_stats["on_beluga_kill_orb_drop"] + (1 if preview else 0)
	return stat_level * 2

static func on_beluga_kill_cd_refund_percent(preview: bool = false) -> float:
	var stat_level: int = GlobalStats.current_run_stats["on_beluga_kill_cd_refund"] + (1 if preview else 0)
	return 1 - 0.75 ** stat_level

static func on_beluga_kill_size_grow() -> bool:
	return GlobalStats.current_run_stats["on_beluga_kill_size_grow"] > 0
	
static func beluga_special_killer() -> bool:
	return GlobalStats.current_run_stats["beluga_special_killer"] > 0

static func beluga_auto_cast() -> bool:
	return GlobalStats.current_run_stats["beluga_auto_cast"] > 0

static func beluga_freeze_time(preview: bool = false) -> float:
	var stat_level: int = GlobalStats.current_run_stats["beluga_freeze"] + (1 if preview else 0)
	if stat_level == 0:
		return 0.0
	return 3.0 + stat_level * 2.0

static func get_whale_cooldown_reduction() -> float:
	return  0.8 ** GlobalStats.current_run_stats["whale_cooldown_reduction"] 

static func get_speed_up_multiplier() -> float:
	return 1.2 ** GlobalStats.current_run_stats["movement_speed_up"]

static func get_slow_down_multiplier() -> float:
	return 0.8 ** GlobalStats.current_run_stats["movement_slow_down"]

static func get_dash_cooldown_reduction() -> float:
	return 0.75 ** GlobalStats.current_run_stats["dash_cooldown_reduction"]

static func get_dash_cooldown_increase() -> float:
	return 1.2 ** GlobalStats.current_run_stats["dash_cooldown_increase"]

static func get_dash_distance_decrease() -> float:
	return 0.8 ** GlobalStats.current_run_stats["dash_distance_decrease"]

static func has_suicide_dash() -> bool:
	return GlobalStats.current_run_stats["suicide_dash"] > 0

static func get_suicide_dash_cooldown_decrease() -> float: ## this is a multiplier
	return 0.4 if StatCalculator.has_suicide_dash() else 1.0

static func has_dash_reset_on_damage() -> bool:
	return GlobalStats.current_run_stats["dash_reset_on_damage"] > 0

static func dash_damages_status() -> bool:
	return GlobalStats.current_run_stats["special_killer_dash"] > 0

## WHALE  ZONE


static func get_mouse_attack_hitbox_shrink() -> float:
	return 0.8 ** GlobalStats.current_run_stats["player_attack_shrink"]

# static func get_heal_amount() -> int:
# 	return GlobalStats.current_run_stats["heal"] * 5 + 4

# static func get_damage_amount() -> int:
# 	return GlobalStats.current_run_stats["damage"] * 4 + 4

static func get_attracted_radius() -> float:
	return 0.4 + GlobalStats.current_run_stats["xp_suck"] * 1.0

static func get_attracted_speed() -> float:
	return 0.15 + GlobalStats.current_run_stats["xp_suck"] * 0.8

# static func get_bonus_enemy_xp_drop() -> int:
	# return int(GlobalStats.current_run_stats["enemy_xp_drop"])

static func get_enemy_damage() -> int:
	match Config.get_difficulty():
		Config.Difficulty.EASY:
			return 3
		Config.Difficulty.NORMAL:
			return 4
		Config.Difficulty.HARD:
			return 5
	return 4 
	# return ceil(5 + GlobalStats.current_run_stats["enemy_damage"] * 2.5)

# static func get_dash_distance() -> float:
	# return 5.0 + GlobalStats.current_run_stats["dash_distance"] * 3.0

static func get_seconds_per_damage() -> float: ## 2.5 seconds per damage is chill no time change ## was 0.4 now 0.3
	var scaling_amount : float = 0.4
	match Config.get_difficulty():
		Config.Difficulty.EASY:
			scaling_amount = 0.3
		Config.Difficulty.NORMAL:
			scaling_amount = 0.4
		Config.Difficulty.HARD:
			scaling_amount = 0.5
	return 2.0 / (1.0 + GlobalStats.current_run_stats["time_tick_level"] * scaling_amount) ** 1.1

static func get_enemy_projectile_flat() -> int:
	return 0

static func get_enemy_attack_speed_multiplier() -> float:
	return 1.0

static func get_enemy_speed_multiplier() -> float:
	return 1.0

static func get_enemy_health_flat() -> float:
	return 0

static func get_whale_size() -> float:
	return 0.14 + GlobalStats.current_run_stats["whale_size"] * 0.05 ## previously 0.14

static func get_attack_speed_multiplier() -> float:
	return 1.0 + GlobalStats.current_run_stats["player_attack_speed"] * 0.3

static func has_dash() -> bool:
	return true
	# return GlobalStats.current_run_stats["has_dash"] > 0

static func is_positive_stat(stat_name: String) -> bool:
	if stat_name in ["xp_suck", "enemy_xp_drop", "whale_size", "dash_distance", "player_attack_speed"]:
		return true
	elif stat_name in ["time_tick_level", "enemy_speed", "enemy_health", "damage", "enemy_damage"]:
		return false
	return true


## boss zone
static func get_num_boss_blessings() -> int:
	return GlobalStats.boss_stats["num_blessings"]

static func get_num_boss_curses() -> int:
	return GlobalStats.boss_stats["num_curses"]

static func get_boss_freeze_time(preview: bool = false) -> int:
	var stat_level: int = GlobalStats.current_run_stats["boss_freeze_time"] + (1 if preview else 0)
	return stat_level * 10

static func get_num_whales() -> int:
	return GlobalStats.current_run_stats["num_whales"] + 1

static func get_decay_duration_on_hit() -> int:
	return GlobalStats.current_run_stats["curse_on_hit"]

static func get_extra_boss_health() -> int:
	return GlobalStats.current_run_stats["extra_boss_health"] * 7

static func get_critical_damage(preview: bool = false) -> int:
	var stat_level: int = GlobalStats.current_run_stats["critical_damage"] + (1 if preview else 0)
	return 1 + stat_level

static func get_boss_xp_drop_per_hit(preview: bool = false) -> int:
	var stat_level: int = GlobalStats.current_run_stats["boss_xp_drop"] + (1 if preview else 0)
	return stat_level

static func get_boss_attack_size_multiplier() -> float:
	return 1.0 + GlobalStats.current_run_stats["boss_attack_size"] * 0.5

#gen 2
static func get_decay_on_damaged() -> int:
	return GlobalStats.current_run_stats["decay_on_damaged"]

static func get_bigger_attack_every_n_hits(preview: bool = false) -> int:
	var stat_level: int = GlobalStats.current_run_stats["bigger_attack_every_n_hits"] + (1 if preview else 0)
	if stat_level == 0:
		return 0
	return max(2, 7 - stat_level)

# bomb zone
static func has_dash_bomb() -> bool:
	return GlobalStats.current_run_stats["dash_bomb"] > 0

static func has_bomber_whale() -> bool:
	return GlobalStats.current_run_stats["bomber_whale"] > 0

static func has_bomb_chain_reaction() -> bool:
	return GlobalStats.current_run_stats["bomb_chain_reaction"] > 0

static func get_bomb_size() -> float:
	return 1.0 + GlobalStats.current_run_stats["bomb_size"] * 0.2

static func get_bomb_tick_time() -> float:
	return 1.8 * (0.8 ** GlobalStats.current_run_stats["bomb_tick_time"])

static func get_super_bomb_chance() -> float:
	if GlobalStats.current_run_stats["bomb_crit"] == 0:
		return 0.0
	return 0.3 + GlobalStats.current_run_stats["bomb_crit"] * 0.1

static func get_lucky_bomb_roll_times() -> int:
	return GlobalStats.current_run_stats["bomb_orb_drop"]

static func has_poison_bombs() -> bool:
	return GlobalStats.current_run_stats["poison_bombs"] > 0

# poison zone
static func has_poison_beluga() -> bool:
	return GlobalStats.current_run_stats["poison_beluga"] > 0

static func has_poison_ebb_attack() -> bool:
	return GlobalStats.current_run_stats["poison_ebb_attack"] > 0

static func has_poison_enemies_drop_bombs() -> bool:
	return GlobalStats.current_run_stats["poison_enemies_drop_bombs"] > 0

static func get_poisoned_enemies_drop_ebbs() -> int:
	return GlobalStats.current_run_stats["poisoned_enemies_drop_ebbs"] * 2

static func get_poison_kills_drop_orbs(preview : bool = false) -> int:
	var stat_level: int = GlobalStats.current_run_stats["poison_kills_drop_orbs"] + (1 if preview else 0)
	return stat_level * 2

static func get_poison_tick_multiplier() -> float:
	var m : float = 1.0 - GlobalStats.current_run_stats["faster_poison"] * 0.2
	m *= pow(1.5, GlobalStats.current_run_stats["slower_poison_more_lethal"])
	return max(m, 0.1)

static func get_poison_expiry_damage() -> int:
	return GlobalStats.current_run_stats["slower_poison_more_lethal"] + 1

#mark zone
static func has_marking_dash() -> bool:
	return GlobalStats.current_run_stats["marking_dash"] > 0

static func has_marking_beluga() -> bool:
	return GlobalStats.current_run_stats["marking_beluga"] > 0

static func marks_needed_to_make_bomb(preview: bool = false) -> int:
	var stat_level: int = GlobalStats.current_run_stats["mark_makes_a_bomb"] + (1 if preview else 0)
	if stat_level == 0:
		return 0
	return max(1, 5 - stat_level)

static func mark_to_orb() -> int:
	return GlobalStats.current_run_stats["mark_to_orb"]

static func auto_consume_mark() -> bool:
	return GlobalStats.current_run_stats["auto_consume_mark"] > 0


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
	return  GlobalStats.current_run_stats["enemy_spawn_ebby"] * 0.2
	
static func get_chance_to_spawn_infested() -> float:
	return  GlobalStats.current_run_stats["enemy_spawn_infested"] * 0.25

static func get_chance_to_spawn_cursed() -> float:
	return  GlobalStats.current_run_stats["enemy_spawn_cursed"] * 0.2

static func get_chance_to_spawn_berserk() -> float:
	return  GlobalStats.current_run_stats["enemy_spawn_berserk"] *  0.25

static func get_chance_to_spawn_slippery() -> float:
	return  GlobalStats.current_run_stats["enemy_spawn_slippery"] *  0.25

static func get_chance_to_spawn_spikey() -> float:
	return  GlobalStats.current_run_stats["enemy_spawn_spikey"] *  0.25

static func get_chance_to_spawn_wither() -> float:
	return  GlobalStats.current_run_stats["enemy_spawn_wither"] * 0.2

static func get_chance_to_spawn_poisoned() -> float:
	return  GlobalStats.current_run_stats["enemy_spawn_poisoned"] * 0.2

static func get_chance_to_spawn_marked() -> float:
	return  GlobalStats.current_run_stats["enemy_spawn_marked"] * 0.2

static func get_chance_to_spawn_shielded() -> float:
	return  GlobalStats.current_run_stats["enemy_spawn_shielded"] *  0.25















## oldies

# static func speed_during_status() -> float:
	# return 0.5 + GlobalStats.current_run_stats["fast_while_status"] * 0.3

# static func has_thorns() -> bool:
	# return GlobalStats.current_run_stats["thornmail"] > 0

# static func get_thorns_damage() -> int:
# 	return GlobalStats.current_run_stats["thornmail"]

# static func get_damage_reduced_by() -> int:
	# return 1 + GlobalStats.current_run_stats["damage_reduction"]

static func get_dying_ebb(preview: bool = false) -> int:
	var stat_level: int = GlobalStats.current_run_stats["dying_ebb"] + (1 if preview else 0)
	if stat_level > 0:
		return 1 + stat_level * 3
	return 0

static func get_ebb_begin_of_room(preview: bool = false) -> int:
	var stat_level: int = GlobalStats.current_run_stats["ebb_begin_of_room"] + (1 if preview else 0)
	if stat_level > 0:
		return 3 + stat_level
	return 0

static func get_midas_dash_touch_num(preview: bool = false) -> int:
	var stat_level: int = GlobalStats.current_run_stats["midas_dash_touch"] + (1 if preview else 0)
	return stat_level * 2

static func get_jump_kill_orb_num(preview: bool = false) -> int:
	var stat_level: int = GlobalStats.current_run_stats["jump_kill_orb"] + (1 if preview else 0)
	return stat_level * 2


static func get_damage_reduced_by() -> int:
	return 0

static func get_ebb_on_stand() -> bool:
	return false
	# return GlobalStats.current_run_stats["ebb_on_stand"] > 0

# static func get_dash_damage() -> int:
# 	return GlobalStats.current_run_stats["damaging_dash"]

# static func get_ebb_drop() -> int:
# 	return GlobalStats.current_run_stats["ebb_drop"]


# static func get_whale_damage_flat() -> int:
	# return GlobalStats.current_run_stats["whale_damage"] + 1
