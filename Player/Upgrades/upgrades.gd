extends Node
class_name Upgrades

static func _static_init() -> void:
	# UpgradeBuilder.new("heal", "Time in a Jar") \
	# 	.pool(UpgradePool.BLESSING) \
	# 	.description_fn(_heal_desc) \
	# 	.augment(-5) \
	# 	.effect(HealScaledEffect.new()) \
	# 	.effect(IncreaseStatEffect.new(&"heal")) \
	# 	.register()
	UpgradeBuilder.new("xp_suck", "Orb Catcher") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(_xp_suck_desc) \
		.augment(-5) \
		.effect(IncreaseStatEffect.new(&"xp_suck")) \
		.register()
	# UpgradeBuilder.new("enemy_xp_drop", "Feast Totem") \
	# 	.pool(UpgradePool.BLESSING) \
	# 	.description_fn(_enemy_xp_drop_desc) \
	# 	.augment(-5) \
	# 	.effect(IncreaseStatEffect.new(&"enemy_xp_drop")) \
	# 	.register()
	# UpgradeBuilder.new("whale_size", "Beluga Plushie") \
	# 	.pool(UpgradePool.WHALE_BLESSING) \
	# 	.description_fn(_whale_desc) \
	# 	.augment(-5) \
	# 	.effect(IncreaseStatEffect.new(&"whale_size")) \
	# 	.register()
	# UpgradeBuilder.new("whale_cooldown", "Beluga Boon") \
	# 	.pool(UpgradePool.WHALE_BLESSING) \
	# 	.description_fn(_whale_cooldown_desc) \
	# 	.augment(-5) \
	# 	.prereqs([&"whale_size"]) \
	# 	.effect(IncreaseStatEffect.new(&"whale_cooldown")) \
	# 	.register()
	# UpgradeBuilder.new("whale_damage", "Beluga Fangs") \
	# 	.pool(UpgradePool.WHALE_BLESSING) \
	# 	.description_fn(_whale_damage_desc) \
	# 	.augment(-5) \
	# 	.prereqs([&"whale_size"]) \
	# 	.effect(IncreaseStatEffect.new(&"whale_damage")) \
	# 	.register()
	# UpgradeBuilder.new("dash_distance", "VROOM!!") \
	# 	.pool(UpgradePool.ONE_TIME_BLESSING) \
	# 	.description_fn(_dash_desc) \
	# 	.augment(-5) \
	# 	.effect(IncreaseStatEffect.new(&"dash_distance")) \
	# 	.register()
	UpgradeBuilder.new("time_tick_level", "Dark Algae") \
		.pool(UpgradePool.BIG_CURSE) \
		.description_fn(_time_tick_desc) \
		.augment(8) \
		.effect(IncreaseStatEffect.new(&"time_tick_level")) \
		.register()
	# UpgradeBuilder.new("damage", "Little Bite") \
	# 	.pool(UpgradePool.CURSE) \
	# 	.description_fn(_damage_desc) \
	# 	.augment(8) \
	# 	.effect(DamageScaledEffect.new()) \
	# 	.effect(IncreaseStatEffect.new(&"damage")) \
	# 	.register()
	# UpgradeBuilder.new("enemy_speed", "Flying Shell") \
	# 	.pool(UpgradePool.CURSE) \
	# 	.description_fn(_enemy_speed_desc) \
	# 	.augment(8) \
	# 	.effect(IncreaseStatEffect.new(&"enemy_speed")) \
	# 	.register()
	# UpgradeBuilder.new("enemy_attack_speed", "Piranha Fangs") \
	# 	.pool(UpgradePool.CURSE) \
	# 	.description_fn(_enemy_attack_speed_desc) \
	# 	.augment(8) \
	# 	.effect(IncreaseStatEffect.new(&"enemy_attack_speed")) \
	# 	.register()
	# UpgradeBuilder.new("enemy_health", "Bulk Up") \
	# 	.pool(UpgradePool.CURSE) \
	# 	.description_fn(_enemy_health_desc) \
	# 	.augment(8) \
	# 	.effect(IncreaseStatEffect.new(&"enemy_health")) \
	# 	.register()
	# UpgradeBuilder.new("enemy_damage", "Poseidon's Fury") \
	# 	.pool(UpgradePool.CURSE) \
	# 	.description_fn(_enemy_damage_desc) \
	# 	.augment(8) \
	# 	.effect(IncreaseStatEffect.new(&"enemy_damage")) \
	# 	.register()
	# UpgradeBuilder.new("attack_size", "Giant Potato") \
	# 	.pool(UpgradePool.BLESSING) \
	# 	.description_fn(_attack_size_desc) \
	# 	.augment(-5) \
	# 	.effect(IncreaseStatEffect.new(&"attack_size")) \
	# 	.register()
	# UpgradeBuilder.new("player_attack_speed", "Sonic Seashell") \
	# 	.pool(UpgradePool.BLESSING) \
	# 	.description_fn(_attack_speed_desc) \
	# 	.augment(-5) \
	# 	.effect(IncreaseStatEffect.new(&"player_attack_speed")) \
	# 	.register()
	# UpgradeBuilder.new("ebb_drop", "Ebb Essence") \
	# 	.pool(UpgradePool.BLESSING) \
	# 	.description_fn(_ebb_drop_desc) \
	# 	.augment(-5) \
	# 	.effect(IncreaseStatEffect.new(&"ebb_drop")) \
	# 	.register()
	# UpgradeBuilder.new("ebb_on_stand", "Ebb's Embrace") \
	# 	.pool(UpgradePool.ONE_TIME_BLESSING) \
	# 	.description_fn(_ebb_on_stand_desc) \
	# 	.augment(-5) \
	# 	.effect(IncreaseStatEffect.new(&"ebb_on_stand")) \
	# 	.register()
	UpgradeBuilder.new("dying_ebb", "Last Stand") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(_dying_ebb_desc) \
		.augment(-5) \
		.effect(IncreaseStatEffect.new(&"dying_ebb")) \
		.register()
	UpgradeBuilder.new("movement_speed_flat", "Streamlined") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "+0.75 flat movement speed") \
		.augment(-5) \
		.effect(IncreaseStatEffect.new(&"movement_speed_flat")) \
		.register()
	UpgradeBuilder.new("ebb_begin_of_room", "Tidal Surge") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Gain %d seconds of Ebb at the start of each room" % (3 + GlobalStats.current_run_stats["ebb_begin_of_room"] + 1)) \
		.augment(-5) \
		.effect(IncreaseStatEffect.new(&"ebb_begin_of_room")) \
		.register()
	UpgradeBuilder.new("orb_weight", "Heavy Current") \
		.pool(UpgradePool.CURSE) \
		.description_fn(func() -> String: return "Orbs attract faster and wider, but you move slower") \
		.augment(8) \
		.effect(IncreaseStatEffect.new(&"xp_suck")) \
		.effect(IncreaseStatEffect.new(&"movement_slow_down")) \
		.register()
	UpgradeBuilder.new("burst_movement", "Burst Fins") \
		.pool(UpgradePool.CURSE) \
		.description_fn(func() -> String: return "+10%% movement speed, but dash recharges slower") \
		.augment(8) \
		.effect(IncreaseStatEffect.new(&"movement_speed_up")) \
		.effect(IncreaseStatEffect.new(&"dash_cooldown_increase")) \
		.register()
	UpgradeBuilder.new("speed_on_pickup", "Flow State") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Picking up any orb grants a 1.5s movement speed boost (stacks in power, not time)") \
		.augment(-5) \
		.effect(IncreaseStatEffect.new(&"speed_on_pickup")) \
		.register()
	UpgradeBuilder.new("deaths_dance", "Death's Dance") \
		.pool(UpgradePool.CURSE) \
		.description_fn(func() -> String: return "Take only 1 damage per hit, but each hit applies 1.5s of Haste/Decay") \
		.augment(8) \
		.effect(IncreaseStatEffect.new(&"deaths_dance")) \
		.register()
	# UpgradeBuilder.new("damaging_dash", "Shark Teeth") \
	# 	.pool(UpgradePool.ONE_TIME_BLESSING) \
	# 	.description_fn(_damaging_dash_desc) \
	# 	.augment(-5) \
	# 	.prereqs([&"dash_distance"]) \
	# 	.effect(IncreaseStatEffect.new(&"damaging_dash")) \
	# 	.register()
	# UpgradeBuilder.new("damage_reduction", "Big Shell") \
	# 	.pool(UpgradePool.BLESSING) \
	# 	.description_fn(_damge_reduction_desc) \
	# 	.augment(-5) \
	# 	.effect(IncreaseStatEffect.new(&"damage_reduction")) \
	# 	.register()
	# UpgradeBuilder.new("thornmail", "Thornmail") \
	# 	.pool(UpgradePool.BLESSING) \
	# 	.description_fn(_thornmail_desc) \
	# 	.augment(-5) \
	# 	.effect(IncreaseStatEffect.new(&"thornmail")) \
	# 	.register()
	# UpgradeBuilder.new("fast_while_status", "Swift Current") \
	# 	.pool(UpgradePool.BLESSING) \
	# 	.description_fn(_fast_during_status_desc) \
	# 	.augment(-5) \
	# 	.effect(IncreaseStatEffect.new(&"fast_while_status")) \
	# 	.register()
	# UpgradeBuilder.new("flat_speed", "Eel boots?") \
	# 	.pool(UpgradePool.BLESSING) \
	# 	.description_fn(_flat_speed_desc) \
	# 	.augment(-5) \
	# 	.effect(IncreaseStatEffect.new(&"flat_speed")) \
	# 	.register()

	UpgradeBuilder.new("extra_boss_health", "Angler's Feast") \
		.pool(UpgradePool.BOSS_CURSE) \
		.description_fn(_extra_boss_health_desc) \
		.effect(IncreaseStatEffect.new(&"extra_boss_health")) \
		.register()
	UpgradeBuilder.new("curse_on_hit", "Poisonous Touch") \
		.pool(UpgradePool.BOSS_CURSE) \
		.description_fn(_curse_on_hit_desc) \
		.effect(IncreaseStatEffect.new(&"curse_on_hit")) \
		.register()
	UpgradeBuilder.new("boss_attack_size", "Massive Tentacles") \
		.pool(UpgradePool.BOSS_CURSE) \
		.description_fn(_boss_attack_size_desc) \
		.effect(IncreaseStatEffect.new(&"boss_attack_size")) \
		.register()

	UpgradeBuilder.new("boss_freeze", "Frozen Time") \
		.pool(UpgradePool.BOSS_BLESSING) \
		.description_fn(_boss_freeze_desc) \
		.effect(IncreaseStatEffect.new(&"boss_freeze_time")) \
		.register()
	UpgradeBuilder.new("num_whales", "Whale Song") \
		.pool(UpgradePool.BOSS_BLESSING) \
		.description_fn(_num_whales_desc) \
		.prereqs([&"whale_size"]) \
		.effect(IncreaseStatEffect.new(&"num_whales")) \
		.register()
	UpgradeBuilder.new("boss_xp_drop", "Angler Hunter") \
		.pool(UpgradePool.BOSS_BLESSING) \
		.description_fn(_enemy_xp_drop_desc) \
		.effect(IncreaseStatEffect.new(&"boss_xp_drop")) \
		.register()
	UpgradeBuilder.new("critical_chance", "Sharpshell") \
		.pool(UpgradePool.BOSS_BLESSING) \
		.description_fn(_critical_chance_desc) \
		.effect(IncreaseStatEffect.new(&"critical_chance")) \
		.register()


	# new curses!
	UpgradeBuilder.new("enemy_spawn_berserk", "Berserk Spawns") \
		.pool(UpgradePool.CURSE) \
		.description_fn(func() -> String: return "Enemies have a chance to spawn berserk!") \
		.augment(8) \
		.effect(IncreaseStatEffect.new(&"enemy_spawn_berserk")) \
		.register()
	
	UpgradeBuilder.new("enemy_spawn_cursed", "Cursed Spawns") \
		.pool(UpgradePool.CURSE) \
		.description_fn(func() -> String: return "Enemies have a chance to spawn cursed!") \
		.augment(8) \
		.effect(IncreaseStatEffect.new(&"enemy_spawn_cursed")) \
		.register()
	UpgradeBuilder.new("enemy_spawn_slippery", "Slippery Spawns") \
		.pool(UpgradePool.CURSE) \
		.description_fn(func() -> String: return "Enemies have a chance to spawn slippery!") \
		.augment(8) \
		.effect(IncreaseStatEffect.new(&"enemy_spawn_slippery")) \
		.register()
	UpgradeBuilder.new("enemy_spawn_spikey", "Spikey Spawns") \
		.pool(UpgradePool.CURSE) \
		.description_fn(func() -> String: return "Enemies have a chance to spawn spikey!") \
		.augment(8) \
		.effect(IncreaseStatEffect.new(&"enemy_spawn_spikey")) \
		.register()
	UpgradeBuilder.new("enemy_spawn_wither", "Withering Spawns") \
		.pool(UpgradePool.CURSE) \
		.description_fn(func() -> String: return "Enemies have a chance to spawn withering!") \
		.augment(8) \
		.effect(IncreaseStatEffect.new(&"enemy_spawn_wither")) \
		.register()
	UpgradeBuilder.new("enemy_spawn_shielded", "Shielded Spawns") \
		.pool(UpgradePool.CURSE) \
		.description_fn(func() -> String: return "Enemies have a chance to spawn shielded!") \
		.augment(8) \
		.effect(IncreaseStatEffect.new(&"enemy_spawn_shielded")) \
		.register()
	
	UpgradeBuilder.new("enemy_spawn_infested", "Infested Spawns") \
		.pool(UpgradePool.CURSE) \
		.description_fn(func() -> String: return "Enemies have a chance to spawn infested!") \
		.augment(8) \
		.effect(IncreaseStatEffect.new(&"enemy_spawn_infested")) \
		.register()

	UpgradeBuilder.new("enemy_spawn_poisoned", "Poisonous Spawns") \
		.pool(UpgradePool.CURSE) \
		.description_fn(func() -> String: return "Enemies have a chance to spawn poisoned!") \
		.augment(-5) \
		.effect(IncreaseStatEffect.new(&"enemy_spawn_poisoned")) \
		.register()

	UpgradeBuilder.new("enemy_spawn_marked", "Marked Spawns") \
		.pool(UpgradePool.CURSE) \
		.description_fn(func() -> String: return "Enemies have a chance to spawn marked!") \
		.augment(-5) \
		.effect(IncreaseStatEffect.new(&"enemy_spawn_marked")) \
		.register()

	UpgradeBuilder.new("mark_to_orb", "Marked Harvest") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Consuming marks drops time orbs!") \
		.augment(-5) \
		.effect(IncreaseStatEffect.new(&"mark_to_orb")) \
		.register()

	UpgradeBuilder.new("auto_consume_mark", "Overloaded Marks") \
		.pool(UpgradePool.ONE_TIME_BLESSING) \
		.description_fn(func() -> String: return "Applying a 6th mark auto-consumes all 5, dealing 5 damage!") \
		.augment(-5) \
		.effect(IncreaseStatEffect.new(&"auto_consume_mark")) \
		.register()

	UpgradeBuilder.new("poison_beluga", "Toxic Beluga") \
		.pool(UpgradePool.WHALE_BLESSING) \
		.description_fn(func() -> String: return "Beluga poisons enemies on hit!") \
		.augment(-5) \
		.prereqs([&"whale_size"]) \
		.effect(IncreaseStatEffect.new(&"poison_beluga")) \
		.register()

	UpgradeBuilder.new("poison_ebb_attack", "Poisonous Current") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Your attacks poison enemies while you have ebb!") \
		.augment(-5) \
		.effect(IncreaseStatEffect.new(&"poison_ebb_attack")) \
		.register()

	UpgradeBuilder.new("poison_enemies_drop_bombs", "Toxic Explosion") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Poisoned enemies drop a bomb when they die!") \
		.augment(-5) \
		.effect(IncreaseStatEffect.new(&"poison_enemies_drop_bombs")) \
		.register()

	UpgradeBuilder.new("poisoned_enemies_drop_ebbs", "Toxic Tribute") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Poisoned enemies drop ebb orbs when they die!") \
		.augment(-5) \
		.effect(IncreaseStatEffect.new(&"poisoned_enemies_drop_ebbs")) \
		.register()

	UpgradeBuilder.new("poison_kills_drop_orbs", "Toxic Harvest") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Enemies killed by poison drop time orbs!") \
		.augment(-5) \
		.effect(IncreaseStatEffect.new(&"poison_kills_drop_orbs")) \
		.register()

	UpgradeBuilder.new("faster_poison", "Accelerated Venom") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Poison ticks faster!") \
		.augment(-5) \
		.effect(IncreaseStatEffect.new(&"faster_poison")) \
		.register()

	UpgradeBuilder.new("slower_poison_more_lethal", "Lethal Seep") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Poison ticks slower but deals double damage!") \
		.augment(-5) \
		.effect(IncreaseStatEffect.new(&"slower_poison_more_lethal")) \
		.register()

	UpgradeBuilder.new("whale_cooldown_reduction", "Tidal Rhythm") \
		.pool(UpgradePool.WHALE_BLESSING) \
		.description_fn(func() -> String: return "Beluga's cooldown decreases!") \
		.augment(-5) \
		.prereqs([&"whale_size"]) \
		.effect(IncreaseStatEffect.new(&"whale_cooldown_reduction")) \
		.register()

	UpgradeBuilder.new("whale_size_big", "Mega Beluga") \
		.pool(UpgradePool.WHALE_BLESSING) \
		.description_fn(func() -> String: return "Beluga grows much bigger!") \
		.augment(-5) \
		.prereqs([&"whale_size"]) \
		.effect(IncreaseStatEffect.new(&"whale_size")) \
		.effect(IncreaseStatEffect.new(&"whale_size")) \
		.effect(IncreaseStatEffect.new(&"whale_size")) \
		.register()

	UpgradeBuilder.new("on_beluga_kill_orb_drop", "Whale's Bounty") \
		.pool(UpgradePool.WHALE_BLESSING) \
		.description_fn(_beluga_orb_drop_desc) \
		.augment(-5) \
		.prereqs([&"whale_size"]) \
		.effect(IncreaseStatEffect.new(&"on_beluga_kill_orb_drop")) \
		.register()

	UpgradeBuilder.new("on_beluga_kill_cd_refund", "Whale's Momentum") \
		.pool(UpgradePool.WHALE_BLESSING) \
		.description_fn(_beluga_cd_refund_desc) \
		.augment(-5) \
		.prereqs([&"whale_size"]) \
		.effect(IncreaseStatEffect.new(&"on_beluga_kill_cd_refund")) \
		.register()

	UpgradeBuilder.new("on_beluga_kill_size_grow", "Feeding Frenzy") \
		.pool(UpgradePool.ONE_TIME_BLESSING) \
		.description_fn(func() -> String: return "Each kill by Beluga permanently increases Beluga's size!") \
		.augment(-5) \
		.prereqs([&"whale_size"]) \
		.effect(IncreaseStatEffect.new(&"on_beluga_kill_size_grow")) \
		.register()

	UpgradeBuilder.new("beluga_special_killer", "Status Predator") \
		.pool(UpgradePool.ONE_TIME_BLESSING) \
		.description_fn(func() -> String: return "Beluga deals 1 extra damage to enemies with a status effect!") \
		.augment(-5) \
		.prereqs([&"whale_size"]) \
		.effect(IncreaseStatEffect.new(&"beluga_special_killer")) \
		.register()

	UpgradeBuilder.new("beluga_auto_cast", "Autonomous Beluga") \
		.pool(UpgradePool.ONE_TIME_BLESSING) \
		.description_fn(func() -> String: return "Beluga casts itself automatically when its cooldown is ready!") \
		.augment(-5) \
		.prereqs([&"whale_size"]) \
		.effect(IncreaseStatEffect.new(&"beluga_auto_cast")) \
		.register()

	UpgradeBuilder.new("beluga_freeze", "Frozen Tide") \
		.pool(UpgradePool.ONE_TIME_BLESSING) \
		.description_fn(_beluga_freeze_desc) \
		.augment(-5) \
		.prereqs([&"whale_size"]) \
		.effect(IncreaseStatEffect.new(&"beluga_freeze")) \
		.register()

	UpgradeBuilder.new("dash_cooldown_reduction", "Slippery Fins") \
		.pool(UpgradePool.ONE_TIME_BLESSING) \
		.description_fn(_dash_cooldown_reduction_desc) \
		.augment(-5) \
		.prereqs([&"dash_distance"]) \
		.effect(IncreaseStatEffect.new(&"dash_cooldown_reduction")) \
		.effect(IncreaseStatEffect.new(&"movement_slow_down")) \
		.register()

	UpgradeBuilder.new("dash_cooldown_increase", "Dashing Blur") \
		.pool(UpgradePool.ONE_TIME_BLESSING) \
		.description_fn(_dash_cooldown_increase_desc) \
		.augment(-5) \
		.prereqs([&"dash_distance"]) \
		.effect(IncreaseStatEffect.new(&"dash_cooldown_increase")) \
		.effect(IncreaseStatEffect.new(&"movement_speed_up")) \
		.register()

	UpgradeBuilder.new("suicide_dash", "Reckless Rush") \
		.pool(UpgradePool.ONE_TIME_BLESSING) \
		.description_fn(_suicide_dash_desc) \
		.augment(-5) \
		.prereqs([&"dash_distance"]) \
		.effect(IncreaseStatEffect.new(&"suicide_dash")) \
		.effect(IncreaseStatEffect.new(&"dash_cooldown_reduction")) \
		.register()

	UpgradeBuilder.new("dash_reset_on_damage", "Pain Surge") \
		.pool(UpgradePool.ONE_TIME_BLESSING) \
		.description_fn(_dash_reset_on_damage_desc) \
		.augment(-5) \
		.prereqs([&"dash_distance"]) \
		.effect(IncreaseStatEffect.new(&"dash_reset_on_damage")) \
		.effect(IncreaseStatEffect.new(&"dash_cooldown_increase")) \
		.register()

	UpgradeBuilder.new("special_killer_dash", "Status Slasher") \
		.pool(UpgradePool.ONE_TIME_BLESSING) \
		.description_fn(_dash_damages_status_desc) \
		.augment(-5) \
		.prereqs([&"dash_distance"]) \
		.effect(IncreaseStatEffect.new(&"special_killer_dash")) \
		.effect(IncreaseStatEffect.new(&"dash_cooldown_increase")) \
		.register()


# --- public methods ---
static func chosen_upgrade(upgrade_data : UpgradeData) -> void:
	if upgrade_data.blessing_type == UpgradePool.ONE_TIME_BLESSING:
		UpgradeRegistry.erase(upgrade_data.internal_name)


static func get_upgrade(internal_name: String) -> UpgradeData:
	return UpgradeRegistry.get_by_name(internal_name)

static func get_randomized_augmented_upgrades(type: Array[String], amount: int) -> Array[UpgradeData]:
	var random_sample : Array[UpgradeData] = get_randomized_upgrades(type, amount)
	var augmented_sample : Array[UpgradeData] = []
	for upgrade: UpgradeData in random_sample:
		augmented_sample.append(upgrade.with_augment_cost())
	return augmented_sample


static func get_randomized_upgrades(type: Array[String], amount: int, do_upgrade : bool = true) -> Array[UpgradeData]:
	var chosen_upgrades : Array[UpgradeData] = UpgradePicker.pick(type, amount)
	if not do_upgrade:
		return chosen_upgrades

	var new_upgrades : Array[UpgradeData] = []
	var cursed : bool = false
	for upgrade: UpgradeData in chosen_upgrades:
		if upgrade.blessing_type == UpgradePool.BIG_CURSE:
			TutorialManager.show_tutorial(TutorialManager.TutorialEnum.BELUGAS_BLESSING)
			new_upgrades.append(upgrade.with_beluga_blessing())
		else:
			var rand_val : float = randf()
			if rand_val < 0.15 and not cursed:
				TutorialManager.show_tutorial(TutorialManager.TutorialEnum.ANGLERS_CURSE)
				new_upgrades.append(upgrade.with_angler_curse())
				cursed = true
			else:
				new_upgrades.append(upgrade)
	return new_upgrades


# ------- DESCRIPTION FUNCTIONS -------
static func _heal_desc() -> String:
	return "Take some time! Increase every time you choose it!"

static func _damage_desc() -> String:
	return "Lose some time! Increase every time you choose it!"

static func _xp_suck_desc() -> String:
	return "Orbs are attracted to you!"

static func _enemy_xp_drop_desc() -> String:
	if GlobalStats.current_run_stats["enemy_xp_drop"] == 0:
		return "Enemies have a chance to drop extra time orbs!"
	else:
		return "Enemies have a chance to drop even more time orbs!"

static func _whale_desc() -> String:
	if not StatCalculator.has_beluga():
		return "Call Beluga to attack enemies!"
	else:
		return "Beluga grows bigger!"

static func _whale_cooldown_desc() -> String:
	if GlobalStats.current_run_stats["whale_cooldown"] == 0:
		return "Beluga can attack more often!"
	else:
		return "Beluga's cooldown is even shorter!"

static func _whale_damage_desc() -> String:
	if GlobalStats.current_run_stats["whale_damage"] == 0:
		return "Beluga's attacks deal more damage!"
	else:
		return "Beluga's attacks deal even more damage!"

static func _dash_desc() -> String:
	if GlobalStats.current_run_stats["dash_distance"] == 0:
		return "You can now dash!"
	return "Even more dashing!"

static func _time_tick_desc() -> String:
	return "Time ticks faster..."

static func _enemy_speed_desc() -> String:
	return "Enemies move faster!"

static func _enemy_attack_speed_desc() -> String:
	return "Enemies attack come out faster!"

static func _enemy_health_desc() -> String:
	return "Enemies take one more hit to kill!"

static func _enemy_damage_desc() -> String:
	return "Enemy attacks deal more damage!"

static func _attack_size_desc() -> String:
	return "Your attacks hit a larger area!"

static func _attack_speed_desc() -> String:
	return "You can attack faster!"

static func _ebb_drop_desc() -> String:
	if GlobalStats.current_run_stats["ebb_drop"] == 0:
		return "Enemies have a chance to drop ebb orbs!"
	else:
		return "Enemies have a chance to drop extra ebb orbs!"

static func _ebb_on_stand_desc() -> String:
	return "Gain ebb while standing still!"

static func _damaging_dash_desc() -> String:
	return "Your dash damages enemies!"

static func _damge_reduction_desc() -> String:
	return "Take less damage!"

static func _thornmail_desc() -> String:
	if GlobalStats.current_run_stats["thornmail"] == 0:
		return "Deal damage to enemies when you get hit!"
	else:
		return "Deal more damage to enemies when you get hit!"

static func _fast_during_status_desc() -> String:
	return "Move faster while affected by a status effect!"

static func _flat_speed_desc() -> String:
	return "Move faster!"

static func _dying_ebb_desc() -> String:
	return "Gain ebb when you are at low health!"


## boss zone

static func _boss_freeze_desc() -> String:
	return "Freeze time for %d seconds" % (StatCalculator.get_boss_freeze_time())

static func _curse_on_hit_desc() -> String:
	return "Bleed when you take damage."

static func _num_whales_desc() -> String:
	return "Summon an extra whale when you call Beluga!"

static func _extra_boss_health_desc() -> String:
	return "Increase boss health!"

static func _critical_chance_desc() -> String:
	return "Your attacks can critically strike for double damage!"

static func _boss_xp_drop_desc() -> String:
	return "Boss drops time orbs when damaged!"

static func _boss_attack_size_desc() -> String:
	return "Boss signature attack hits a larger area!"

static func _dash_cooldown_reduction_desc() -> String:
	return "Dash recharges faster, but you move slower."

static func _dash_cooldown_increase_desc() -> String:
	return "Dash recharges slower, but you move faster."

static func _suicide_dash_desc() -> String:
	return "Dash recharges much faster, but each dash costs 1 health."

static func _dash_reset_on_damage_desc() -> String:
	return "Taking damage instantly resets your dash, but it recharges slower."

static func _dash_damages_status_desc() -> String:
	return "Your dash deals 1 damage to enemies with a status effect, but it recharges slower."

static func _beluga_orb_drop_desc() -> String:
	var current : int = GlobalStats.current_run_stats["on_beluga_kill_orb_drop"]
	if current == 0:
		return "Beluga kills drop time orbs!"
	return "Beluga kills drop even more time orbs! (%d)" % (current + 1)

static func _beluga_cd_refund_desc() -> String:
	var refund : float = StatCalculator.on_beluga_kill_cd_refund_percent() * 100.0
	return "Beluga kills refund %.0f%% of its remaining cooldown!" % refund

static func _beluga_freeze_desc() -> String:
	var t : float = StatCalculator.beluga_freeze_time()
	return "Casting Beluga freezes time for %.0fs! Cooldown increases by the same amount." % t
