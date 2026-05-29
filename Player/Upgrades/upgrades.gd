extends Node
class_name Upgrades

static func ensure_initialized() -> void:
	if UpgradeRegistry._by_name.is_empty():
		_static_init()

static func _static_init() -> void:
	# UpgradeBuilder.new("heal", "Time in a Jar") \
	# 	.pool(UpgradePool.BLESSING) \
	# 	.description_fn(_heal_desc) \
	# 	.augment(-5) \
	# 	.effect(HealScaledEffect.new()) \
	# 	.effect(_stat(&"heal")) \
	# 	.register()
	# UpgradeBuilder.new("xp_suck", "Orb Catcher") \
	# 	.pool(UpgradePool.BLESSING) \
	# 	.description_fn(_xp_suck_desc) \
	# 	.augment(-5) \
	# 	.effect(_stat(&"xp_suck")) \
	# 	.register()
	# UpgradeBuilder.new("enemy_xp_drop", "Feast Totem") \
	# 	.pool(UpgradePool.BLESSING) \
	# 	.description_fn(_enemy_xp_drop_desc) \
	# 	.augment(-5) \
	# 	.effect(_stat(&"enemy_xp_drop")) \
	# 	.register()
	# UpgradeBuilder.new("whale_size", "Beluga Plushie") \
	# 	.pool(UpgradePool.BLESSING) \
	# 	.description_fn(_whale_desc) \
	# 	.augment(-5) \
	# 	.effect(_stat(&"whale_size")) \
	# 	.register()
	# UpgradeBuilder.new("whale_cooldown", "Beluga Boon") \
	# 	.pool(UpgradePool.BLESSING) \
	# 	.description_fn(_whale_cooldown_desc) \
	# 	.augment(-5) \
	# 	.prereqs([&"whale_size"]) \
	# 	.effect(_stat(&"whale_cooldown")) \
	# 	.register()
	# UpgradeBuilder.new("whale_damage", "Beluga Fangs") \
	# 	.pool(UpgradePool.BLESSING) \
	# 	.description_fn(_whale_damage_desc) \
	# 	.augment(-5) \
	# 	.prereqs([&"whale_size"]) \
	# 	.effect(_stat(&"whale_damage")) \
	# 	.register()
	# UpgradeBuilder.new("dash_distance", "VROOM!!") \
	# 	.pool(UpgradePool.ONE_TIME_BLESSING) \
	# 	.description_fn(_dash_desc) \
	# 	.augment(-5) \
	# 	.effect(_stat(&"dash_distance")) \
	# 	.register()

	## generics
	UpgradeBuilder.new("time_tick_level", "Dark Algae") \
		.pool(UpgradePool.CURSE) \
		.description_fn(_time_tick_desc) \
		.augment(8) \
		.effect(_stat(&"time_tick_level")) \
		.effect(_stat(&"player_max_health")) \
		.effect(_stat(&"player_max_health")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.BIG_CURSE]) \
		.register()
	UpgradeBuilder.new("decay_on_hit", "Rotting Touch") \
		.pool(UpgradePool.CURSE) \
		.description_fn(func() -> String: return "Gain decay when hit.") \
		.augment(8) \
		.effect(_stat(&"decay_on_damaged")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.BIG_CURSE, UpgradeTag.DECAY])  \
		.register()
	
	## Good relics
	
	UpgradeBuilder.new("ebb_begin_of_room", "Tidal Surge") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Gain %d seconds of Ebb at the start of each room" % StatCalculator.get_ebb_begin_of_room(true)) \
		.augment(-5) \
		.effect(_stat(&"ebb_begin_of_room")) \
		.tags([UpgradeTag.EBB_SOURCE, UpgradeTag.STACKABLE]) \
		.register()
		
	UpgradeBuilder.new("ebb_dying", "Last Stand") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(_dying_ebb_desc) \
		.augment(-5) \
		.effect(_stat(&"dying_ebb")) \
		.tags([UpgradeTag.EBB_SOURCE, UpgradeTag.STACKABLE]) \
		.unlocks_after(after_n_games.bind(1)) \
		.register()	
	
	# speed
	UpgradeBuilder.new("player_flat_speed", "Streamlined") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "+0.75 flat movement speed") \
		.augment(-5) \
		.effect(_stat(&"movement_speed_flat")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.GENERIC]) \
		.register()
	UpgradeBuilder.new("dash_cooldown_increase", "Dashing Blur") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(_dash_cooldown_increase_desc) \
		.augment(-5) \
		.prereqs([UpgradeTag.DASH_SOURCE]) \
		.effect(_stat(&"dash_cooldown_increase")) \
		.effect(_stat(&"movement_speed_up")) \
		.tags([UpgradeTag.DASH, UpgradeTag.STACKABLE]) \
		.register()
	
	UpgradeBuilder.new("speed_on_pickup", "Flow State") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Picking up any orb grants a 1.5s movement speed boost (stacks in power, not time)") \
		.augment(-5) \
		.effect(_stat(&"speed_on_pickup")) \
		.tags([UpgradeTag.GENERIC, UpgradeTag.STACKABLE]) \
		.unlocks_after(after_n_games.bind(3)) \
		.register()

	# others
	UpgradeBuilder.new("orb_weight", "Orb Catcher") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Orbs attract faster and wider, but you move slower") \
		.augment(8) \
		.effect(_stat(&"xp_suck")) \
		.effect(_stat(&"movement_slow_down")) \
		.tags([UpgradeTag.GENERIC, UpgradeTag.ONETIME]) \
		.limit_stacks(1) \
		.register()

	UpgradeBuilder.new("deaths_dance", "Death's Dance") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Take only 1 damage per hit, but each hit applies 1.0s of Decay") \
		.augment(8) \
		.effect(_stat(&"deaths_dance")) \
		.tags([UpgradeTag.GENERIC, UpgradeTag.ONETIME, UpgradeTag.DECAY]) \
		.unlocks_after(after_n_games.bind(2)) \
		.register()
	# UpgradeBuilder.new("damaging_dash", "Shark Teeth") \
	# 	.pool(UpgradePool.ONE_TIME_BLESSING) \
	# 	.description_fn(_damaging_dash_desc) \
	# 	.augment(-5) \
	# 	.prereqs([&"dash_distance"]) \
	# 	.effect(_stat(&"damaging_dash")) \
	# 	.register()
	# UpgradeBuilder.new("damage_reduction", "Big Shell") \
	# 	.pool(UpgradePool.BLESSING) \
	# 	.description_fn(_damge_reduction_desc) \
	# 	.augment(-5) \
	# 	.effect(_stat(&"damage_reduction")) \
	# 	.register()
	# UpgradeBuilder.new("thornmail", "Thornmail") \
	# 	.pool(UpgradePool.BLESSING) \
	# 	.description_fn(_thornmail_desc) \
	# 	.augment(-5) \
	# 	.effect(_stat(&"thornmail")) \
	# 	.register()
	# UpgradeBuilder.new("fast_while_status", "Swift Current") \
	# 	.pool(UpgradePool.BLESSING) \
	# 	.description_fn(_fast_during_status_desc) \
	# 	.augment(-5) \
	# 	.effect(_stat(&"fast_while_status")) \
	# 	.register()
	# UpgradeBuilder.new("flat_speed", "Eel boots?") \
	# 	.pool(UpgradePool.BLESSING) \
	# 	.description_fn(_flat_speed_desc) \
	# 	.augment(-5) \
	# 	.effect(_stat(&"flat_speed")) \
	# 	.register()



	## marks i guess ------
	UpgradeBuilder.new("marking_dash", "Marking Dash") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Your dash applies a mark.") \
		.augment(-5) \
		.effect(_stat(&"marking_dash")) \
		.effect(_stat(&"dash_cooldown_reduction")) \
		.prereqs([UpgradeTag.DASH_SOURCE]) \
		.tags([UpgradeTag.SOURCE, UpgradeTag.MARK_SOURCE, UpgradeTag.ONETIME, UpgradeTag.DASH]) \
		.unlocks_after(after_n_games.bind(1)) \
		.register()
	
	UpgradeBuilder.new("marking_beluga", "Marking Beluga") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Beluga applies 2 marks.") \
		.augment(-5) \
		.prereqs([UpgradeTag.BELUGA_SOURCE]) \
		.effect(_stat(&"marking_beluga")) \
		.effect(_stat(&"whale_size")) \
		.effect(_stat(&"whale_size")) \
		.tags([UpgradeTag.SOURCE, UpgradeTag.MARK_SOURCE, UpgradeTag.ONETIME, UpgradeTag.BELUGA]) \
		.unlocks_after(after_n_games.bind(2)) \
		.register()

	UpgradeBuilder.new("mark_to_orb", "Marked Harvest") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Consuming marks drops time orbs!") \
		.augment(-5) \
		.effect(_stat(&"mark_to_orb")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.NEEDS_MARK, UpgradeTag.DROPS_ORBS]) \
		.prereqs([UpgradeTag.MARK_SOURCE]) \
		.unlocks_after(after_n_games.bind(1)) \
		.register()

	UpgradeBuilder.new("mark_auto_consume", "Mark Overflow") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Applying a 6th mark auto-consumes all 5, dealing 5 damage!") \
		.augment(-5) \
		.effect(_stat(&"auto_consume_mark")) \
		.tags([UpgradeTag.ONETIME, UpgradeTag.NEEDS_MARK]) \
		.prereqs([UpgradeTag.MARK_SOURCE]) \
		.unlocks_after(after_n_games.bind(5)) \
		.register()
	
	UpgradeBuilder.new("mark_makes_a_bomb", "Bombardment") \
		.pool(UpgradePool.CURSE) \
		.description_fn(func() -> String: return "Applying %d marks spawns a bomb at the enemy's location!" % StatCalculator.marks_needed_to_make_bomb(true)) \
		.augment(8) \
		.effect(_stat(&"mark_makes_a_bomb")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.NEEDS_MARK, UpgradeTag.BOMB_SOURCE, UpgradeTag.SOURCE]) \
		.prereqs([UpgradeTag.MARK_SOURCE]) \
		.limit_stacks(5) \
		.unlocks_after(after_n_games.bind(2)) \
		.register()

	### poison zone

	UpgradeBuilder.new("poison_beluga", "Toxic Beluga") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Beluga poisons enemies on hit!") \
		.augment(-5) \
		.prereqs([UpgradeTag.BELUGA_SOURCE]) \
		.effect(_stat(&"poison_beluga")) \
		.effect(_stat(&"whale_size")) \
		.effect(_stat(&"whale_size")) \
		.tags([UpgradeTag.BELUGA, UpgradeTag.SOURCE, UpgradeTag.ONETIME, UpgradeTag.POISON_SOURCE]) \
		.unlocks_after(after_n_games.bind(4)) \
		.register()

	UpgradeBuilder.new("poison_ebb_attack", "Poisonous Current") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Your attacks poison enemies while you have ebb!") \
		.augment(-5) \
		.effect(_stat(&"poison_ebb_attack")) \
		.tags([UpgradeTag.EBB, UpgradeTag.SOURCE, UpgradeTag.ONETIME, UpgradeTag.POISON_SOURCE]) \
		.unlocks_after(after_n_games.bind(4)) \
		.register()

	UpgradeBuilder.new("poison_enemies_drop_bombs", "Toxic Explosion") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Poisoned enemies drop a bomb when they die!") \
		.augment(-5) \
		.effect(_stat(&"poison_enemies_drop_bombs")) \
		.prereqs([UpgradeTag.POISON_SOURCE]) \
		.tags([UpgradeTag.ONETIME, UpgradeTag.NEEDS_POISON, UpgradeTag.BOMB_SOURCE]) \
		.unlocks_after(after_n_games.bind(5)) \
		.register()

	UpgradeBuilder.new("poison_enemies_drop_ebb", "Toxic Tribute") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Poisoned enemies drop ebb orbs when they die!") \
		.augment(-5) \
		.effect(_stat(&"poisoned_enemies_drop_ebbs")) \
		.tags([ UpgradeTag.NEEDS_POISON, UpgradeTag.EBB_SOURCE, UpgradeTag.STACKABLE]) \
		.prereqs([UpgradeTag.POISON_SOURCE]) \
		.unlocks_after(after_n_games.bind(4)) \
		.register()

	UpgradeBuilder.new("poison_kills_drop_orbs", "Toxic Harvest") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Enemies killed by poison drop %d time orbs!" % StatCalculator.get_poison_kills_drop_orbs(true)) \
		.augment(-5) \
		.effect(_stat(&"poison_kills_drop_orbs")) \
		.tags([ UpgradeTag.NEEDS_POISON, UpgradeTag.DROPS_ORBS, UpgradeTag.STACKABLE]) \
		.prereqs([UpgradeTag.POISON_SOURCE]) \
		.unlocks_after(after_n_games.bind(3)) \
		.register()

	UpgradeBuilder.new("poison_faster", "Accelerated Venom") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Poison ticks faster!") \
		.augment(-5) \
		.effect(_stat(&"faster_poison")) \
		.tags([UpgradeTag.NEEDS_POISON, UpgradeTag.STACKABLE]) \
		.limit_stacks(10) \
		.prereqs([UpgradeTag.POISON_SOURCE]) \
		.unlocks_after(after_n_games.bind(4)) \
		.register()

	UpgradeBuilder.new("poison_slower_more_lethal", "Lethal Seep") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Poison ticks slower but deals 2 damage!") \
		.augment(-5) \
		.effect(_stat(&"slower_poison_more_lethal")) \
		.tags([UpgradeTag.NEEDS_POISON, UpgradeTag.STACKABLE]) \
		.prereqs([UpgradeTag.POISON_SOURCE]) \
		.unlocks_after(after_n_games.bind(5)) \
		.register()

	## BOMB ZONE ----------

	UpgradeBuilder.new("bomb_dash", "Explosive Dash") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Your dash spawns a bomb at the start location!") \
		.augment(-5) \
		.effect(_stat(&"dash_bomb")) \
		.effect(_stat(&"dash_cooldown_reduction")) \
		.prereqs([UpgradeTag.DASH_SOURCE]) \
		.tags([UpgradeTag.ONETIME, UpgradeTag.DASH, UpgradeTag.BOMB_SOURCE, UpgradeTag.SOURCE]) \
		.unlocks_after(after_n_games.bind(4)) \
		.register()

	UpgradeBuilder.new("bomb_whale", "Bomber Whale") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Beluga spawns a bomb on hit!") \
		.augment(-5) \
		.prereqs([UpgradeTag.BELUGA_SOURCE]) \
		.effect(_stat(&"whale_cooldown_reduction")) \
		.effect(_stat(&"bomber_whale")) \
		.tags([UpgradeTag.ONETIME, UpgradeTag.BELUGA, UpgradeTag.BOMB_SOURCE, UpgradeTag.SOURCE]) \
		.unlocks_after(after_n_games.bind(3)) \
		.register()
	
	UpgradeBuilder.new("bomb_chain_reaction", "Chain Reaction") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Bombs you spawn also spawn a smaller bomb on death!") \
		.augment(-5) \
		.effect(_stat(&"bomb_chain_reaction")) \
		.tags([UpgradeTag.ONETIME, UpgradeTag.NEEDS_BOMB]) \
		.prereqs([UpgradeTag.BOMB_SOURCE]) \
		.unlocks_after(after_n_games.bind(5)) \
		.register()

	UpgradeBuilder.new("bomb_size", "Big Bombs") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Your bombs are bigger!") \
		.augment(-5) \
		.effect(_stat(&"bomb_size")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.NEEDS_BOMB]) \
		.prereqs([UpgradeTag.BOMB_SOURCE]) \
		.unlocks_after(after_n_games.bind(4)) \
		.register()
	
	UpgradeBuilder.new("bomb_tick_time", "Fast Bombs") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Your bombs tick faster!") \
		.augment(-5) \
		.effect(_stat(&"bomb_tick_time")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.NEEDS_BOMB]) \
		.prereqs([UpgradeTag.BOMB_SOURCE]) \
		.unlocks_after(after_n_games.bind(3)) \
		.register()
	
	UpgradeBuilder.new("bomb_crit", "Critical Bombs") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Have a chance to spawn a super bomb that does double damage!") \
		.augment(-5) \
		.effect(_stat(&"bomb_crit")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.NEEDS_BOMB]) \
		.limit_stacks(7) \
		.prereqs([UpgradeTag.BOMB_SOURCE]) \
		.unlocks_after(after_n_games.bind(5)) \
		.register()
	
	UpgradeBuilder.new("bomb_drops", "Lucky Bombs") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Your bombs have a chance to drop a pickup when they explode!") \
		.augment(-5) \
		.effect(_stat(&"lucky_bombs")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.NEEDS_BOMB, UpgradeTag.DROPS_ORBS, UpgradeTag.EBB]) \
		.limit_stacks(7) \
		.prereqs([UpgradeTag.BOMB_SOURCE]) \
		.unlocks_after(after_n_games.bind(2)) \
		.register()

	UpgradeBuilder.new("poison_bombs", "Toxic Bombs") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Your bombs poison enemies!") \
		.augment(-5) \
		.effect(_stat(&"poison_bombs")) \
		.tags([UpgradeTag.ONETIME, UpgradeTag.NEEDS_BOMB, UpgradeTag.POISON_SOURCE, UpgradeTag.SOURCE]) \
		.prereqs([UpgradeTag.BOMB_SOURCE]) \
		.unlocks_after(after_n_games.bind(3)) \
		.register()
	
	## WHALE ZONE ---------

	UpgradeBuilder.new("whale_cooldown_reduction", "Tidal Rhythm") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Beluga's cooldown decreases!") \
		.augment(-5) \
		.prereqs([UpgradeTag.BELUGA_SOURCE]) \
		.effect(_stat(&"whale_cooldown_reduction")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.BELUGA]) \
		.register()

	UpgradeBuilder.new("whale_size_big", "Mega Beluga") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Beluga grows much bigger!") \
		.augment(-5) \
		.prereqs([UpgradeTag.BELUGA_SOURCE]) \
		.effect(_stat(&"whale_size")) \
		.effect(_stat(&"whale_size")) \
		.effect(_stat(&"whale_size")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.BELUGA]) \
		.register()

	UpgradeBuilder.new("whale_on_kill_orb_drop", "Whale's Bounty") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(_beluga_orb_drop_desc) \
		.augment(-5) \
		.prereqs([UpgradeTag.BELUGA_SOURCE]) \
		.effect(_stat(&"on_beluga_kill_orb_drop")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.BELUGA, UpgradeTag.DROPS_ORBS]) \
		.register()

	UpgradeBuilder.new("whale_on_kill_cd_refund", "Whale's Momentum") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(_beluga_cd_refund_desc) \
		.augment(-5) \
		.prereqs([UpgradeTag.BELUGA_SOURCE]) \
		.effect(_stat(&"on_beluga_kill_cd_refund")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.BELUGA]) \
		.unlocks_after(after_n_games.bind(3)) \
		.register()

	UpgradeBuilder.new("whale_on_kill_size_grow", "Feeding Frenzy") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Each kill by Beluga permanently increases Beluga's size!") \
		.augment(-5) \
		.prereqs([UpgradeTag.BELUGA_SOURCE]) \
		.effect(_stat(&"on_beluga_kill_size_grow")) \
		.tags([UpgradeTag.ONETIME, UpgradeTag.BELUGA]) \
		.unlocks_after(after_n_games.bind(1)) \
		.register()

	UpgradeBuilder.new("whale_special_killer", "Status Predator") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Beluga deals x2 damage to enemies with a status effect!") \
		.augment(-5) \
		.prereqs([UpgradeTag.BELUGA_SOURCE]) \
		.effect(_stat(&"beluga_special_killer")) \
		.tags([UpgradeTag.ONETIME, UpgradeTag.BELUGA]) \
		.unlocks_after(after_n_games.bind(5)) \
		.register()

	UpgradeBuilder.new("whale_auto_cast", "Autonomous Beluga") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Beluga casts itself automatically when its cooldown is ready!") \
		.augment(-5) \
		.prereqs([UpgradeTag.BELUGA_SOURCE]) \
		.effect(_stat(&"beluga_auto_cast")) \
		.tags([UpgradeTag.ONETIME, UpgradeTag.BELUGA]) \
		.unlocks_after(after_n_games.bind(2)) \
		.register()

	UpgradeBuilder.new("whale_freeze", "Frozen Tide") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(_beluga_freeze_desc) \
		.augment(-5) \
		.prereqs([UpgradeTag.BELUGA_SOURCE]) \
		.effect(_stat(&"beluga_freeze")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.BELUGA]) \
		.unlocks_after(after_n_games.bind(4)) \
		.register()

	# DASH zone ----------

	# UpgradeBuilder.new("dash_cooldown_reduction_move_slow", "Slippery Fins") \
	# 	.pool(UpgradePool.BLESSING) \
	# 	.description_fn(_dash_cooldown_reduction_desc) \
	# 	.augment(-5) \
	# 	.prereqs([UpgradeTag.DASH_SOURCE]) \
	# 	.effect(_stat(&"dash_cooldown_reduction")) \
	# 	.effect(_stat(&"movement_slow_down")) \
	# 	.tags([UpgradeTag.DASH, UpgradeTag.STACKABLE]) \
	# 	.register()



	UpgradeBuilder.new("dash_suicide", "Reckless Rush") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(_suicide_dash_desc) \
		.augment(-5) \
		.prereqs([UpgradeTag.DASH_SOURCE]) \
		.effect(_stat(&"suicide_dash")) \
		.tags([UpgradeTag.DASH, UpgradeTag.ONETIME]) \
		.unlocks_after(after_n_games.bind(1)) \
		.register()

	UpgradeBuilder.new("dash_reset_on_damage", "Pain Surge") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(_dash_reset_on_damage_desc) \
		.augment(-5) \
		.prereqs([UpgradeTag.DASH_SOURCE]) \
		.effect(_stat(&"dash_reset_on_damage")) \
		.tags([UpgradeTag.DASH, UpgradeTag.ONETIME]) \
		.unlocks_after(after_n_games.bind(2)) \
		.register()

	UpgradeBuilder.new("dash_fast_but_short", "Quick Dash") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Dash a shorter distance, but more often!") \
		.augment(-5) \
		.prereqs([UpgradeTag.DASH_SOURCE]) \
		.effect(_stat(&"dash_distance_decrease")) \
		.effect(_stat(&"dash_cooldown_reduction")) \
		.tags([UpgradeTag.DASH, UpgradeTag.STACKABLE]) \
		.register()

	UpgradeBuilder.new("dash_special_killer", "Status Slasher") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(_dash_damages_status_desc) \
		.augment(-5) \
		.prereqs([UpgradeTag.DASH_SOURCE]) \
		.effect(_stat(&"special_killer_dash")) \

		.tags([UpgradeTag.DASH, UpgradeTag.ONETIME]) \
		.unlocks_after(after_n_games.bind(5)) \
		.register()

	UpgradeBuilder.new("dash_midas_touch", "Midas Dash") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(_midas_dash_touch_desc) \
		.augment(-5) \
		.prereqs([UpgradeTag.DASH_SOURCE]) \
		.effect(_stat(&"midas_dash_touch")) \
		.tags([UpgradeTag.DASH, UpgradeTag.STACKABLE, UpgradeTag.DROPS_ORBS]) \
		.register()

	##auto attacks -----
	UpgradeBuilder.new("attack_hop_skip_jump", "Hop Skip Jump") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(_hop_skip_jump_desc) \
		.augment(-5) \
		.effect(_stat(&"bigger_attack_every_n_hits")) \
		.tags([UpgradeTag.GENERIC, UpgradeTag.STACKABLE]) \
		.limit_stacks(5) \
		.unlocks_after(after_n_games.bind(1)) \
		.register()

	UpgradeBuilder.new("attack_precise_jump", "Precise Jump") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Your jump hits smaller area, but more frequent!") \
		.augment(-5) \
		.effect(_stat(&"player_attack_shrink")) \
		.effect(_stat(&"player_attack_speed")) \
		.tags([UpgradeTag.GENERIC, UpgradeTag.STACKABLE]) \
		.register()

	UpgradeBuilder.new("attack_kill_orb", "Lethal Harvest") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(_jump_kill_orb_desc) \
		.augment(-5) \
		.effect(_stat(&"jump_kill_orb")) \
		.tags([UpgradeTag.GENERIC, UpgradeTag.STACKABLE, UpgradeTag.DROPS_ORBS]) \
		.register()



	## givens
	UpgradeBuilder.new("beluga_ability", "Beluga") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Summon Beluga to fight by your side!") \
		.effect(_equip_ability("beluga_ability")) \
		.tags([UpgradeTag.BELUGA_SOURCE, UpgradeTag.ONETIME]) \
		.register()

	UpgradeBuilder.new("homing_ability", "Homing Attack") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Your attacks home in on enemies!") \
		.effect(_equip_ability("homing_ability")) \
		.tags([ UpgradeTag.ONETIME]) \
		.register()

	UpgradeBuilder.new("grappling_ability", "Grappling Hook") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Gain a grappling hook to quickly move around!") \
		.effect(_equip_ability("grappling_ability")) \
		.tags([ UpgradeTag.ONETIME]) \
		.register()
	
	# UpgradeBuilder.new("has_dash", "Dash") \
	# 	.pool(UpgradePool.BLESSING) \
	# 	.description_fn(func() -> String: return "Gain the ability to dash!") \
	# 	.effect(_stat(&"has_dash")) \
	# 	.tags([UpgradeTag.DASH_SOURCE, UpgradeTag.ONETIME]) \
	# 	.register()

	UpgradeBuilder.new("player_max_health", "Tough Skin") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Gain 5 max health!") \
		.augment(-5) \
		.effect(_stat(&"player_max_health")) \
		.tags([UpgradeTag.GENERIC, UpgradeTag.STACKABLE]) \
		.register()


	# enemy spawns ------------------
	UpgradeBuilder.new("enemy_spawn_berserk", "Berserk Spawns") \
		.pool(UpgradePool.CURSE) \
		.description_fn(func() -> String: return "Enemies have a chance to spawn berserk!") \
		.augment(8) \
		.effect(_stat(&"enemy_spawn_berserk")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.SPAWNS_BERSERK]) \
		.register()
	
	UpgradeBuilder.new("enemy_spawn_cursed", "Cursed Spawns") \
		.pool(UpgradePool.CURSE) \
		.description_fn(func() -> String: return "Enemies have a chance to spawn cursed!") \
		.augment(8) \
		.effect(_stat(&"enemy_spawn_cursed")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.SPAWNS_CURSED]) \
		.unlocks_after(after_n_games.bind(2)) \
		.register()
	UpgradeBuilder.new("enemy_spawn_slippery", "Slippery Spawns") \
		.pool(UpgradePool.CURSE) \
		.description_fn(func() -> String: return "Enemies have a chance to spawn slippery!") \
		.augment(8) \
		.effect(_stat(&"enemy_spawn_slippery")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.SPAWNS_SLIPPERY]) \
		.register()
	UpgradeBuilder.new("enemy_spawn_spikey", "Spikey Spawns") \
		.pool(UpgradePool.CURSE) \
		.description_fn(func() -> String: return "Enemies have a chance to spawn spikey!") \
		.augment(8) \
		.effect(_stat(&"enemy_spawn_spikey")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.SPAWNS_SPIKEY]) \
		.register()
	UpgradeBuilder.new("enemy_spawn_wither", "Withering Spawns") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Enemies have a chance to spawn withering!") \
		.augment(8) \
		.effect(_stat(&"enemy_spawn_wither")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.SPAWNS_WITHER]) \
		.unlocks_after(after_n_games.bind(5)) \
		.register()
	UpgradeBuilder.new("enemy_spawn_shielded", "Shielded Spawns") \
		.pool(UpgradePool.CURSE) \
		.description_fn(func() -> String: return "Enemies have a chance to spawn shielded!") \
		.augment(8) \
		.effect(_stat(&"enemy_spawn_shielded")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.SPAWNS_SHIELDED]) \
		.unlocks_after(after_n_games.bind(3)) \
		.register()
	
	UpgradeBuilder.new("enemy_spawn_infested", "Infested Spawns") \
		.pool(UpgradePool.CURSE) \
		.description_fn(func() -> String: return "Enemies have a chance to spawn infested!") \
		.augment(8) \
		.effect(_stat(&"enemy_spawn_infested")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.SPAWNS_INFESTED]) \
		.unlocks_after(after_n_games.bind(1)) \
		.register()

	UpgradeBuilder.new("enemy_spawn_poisoned", "Poisonous Spawns") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Enemies have a chance to spawn poisoned!") \
		.augment(-5) \
		.effect(_stat(&"enemy_spawn_poisoned")) \
		.prereqs([UpgradeTag.POISON_SOURCE]) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.SPAWNS_POISONED]) \
		.unlocks_after(after_n_games.bind(4)) \
		.register()

	UpgradeBuilder.new("enemy_spawn_marked", "Marked Spawns") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Enemies have a chance to spawn marked!") \
		.augment(-5) \
		.effect(_stat(&"enemy_spawn_marked")) \
		.prereqs([UpgradeTag.MARK_SOURCE]) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.SPAWNS_MARKED]) \
		.unlocks_after(after_n_games.bind(2)) \
		.register()
	UpgradeBuilder.new("enemy_spawn_ebby", "Ebby Spawns") \
		.pool(UpgradePool.BLESSING) \
		.description_fn(func() -> String: return "Enemies have a chance to spawn Ebby!") \
		.augment(8) \
		.effect(_stat(&"enemy_spawn_ebby")) \
		.tags([UpgradeTag.STACKABLE, UpgradeTag.EBB_SOURCE, UpgradeTag.SPAWNS_EBBY]) \
		.unlocks_after(after_n_games.bind(1)) \
		.register()

	#boss section ---------------
	UpgradeBuilder.new("boss_extra_health", "Angler's Feast") \
		.pool(UpgradePool.BOSS_CURSE) \
		.description_fn(_extra_boss_health_desc) \
		.effect(_boss_stat(&"extra_boss_health")) \
		.register()
	UpgradeBuilder.new("boss_decay_on_hit", "Decaying Touch") \
		.pool(UpgradePool.BOSS_CURSE) \
		.description_fn(_decaying_touch_desc) \
		.effect(_boss_stat(&"curse_on_hit")) \
		.tags([UpgradeTag.DECAY]) \
		.register()
	UpgradeBuilder.new("boss_attack_size", "Massive Tentacles") \
		.pool(UpgradePool.BOSS_CURSE) \
		.description_fn(_boss_attack_size_desc) \
		.effect(_boss_stat(&"boss_attack_size")) \
		.register()

	UpgradeBuilder.new("boss_freeze", "Frozen Time") \
		.pool(UpgradePool.BOSS_BLESSING) \
		.description_fn(_boss_freeze_desc) \
		.effect(_boss_stat(&"boss_freeze_time")) \
		.register()
	UpgradeBuilder.new("boss_num_whales", "Whale Song") \
		.pool(UpgradePool.BOSS_BLESSING) \
		.description_fn(_num_whales_desc) \
		.prereqs([&"whale_size"]) \
		.effect(_boss_stat(&"num_whales")) \
		.register()
	UpgradeBuilder.new("boss_xp_drop", "Angler Hunter") \
		.pool(UpgradePool.BOSS_BLESSING) \
		.description_fn(_boss_xp_drop_desc) \
		.effect(_boss_stat(&"boss_xp_drop")) \
		.register()
	UpgradeBuilder.new("boss_critical_damage", "Sharpshell") \
		.pool(UpgradePool.BOSS_BLESSING) \
		.description_fn(_critical_damage_desc) \
		.effect(_boss_stat(&"critical_damage")) \
		.register()

# --- public methods ---

static func _stat(s: StringName) -> Callable:
	return func() -> void: GlobalStats.add_to_stat(s)

static func _boss_stat(s: StringName) -> Callable:
	return func() -> void: GlobalStats.add_to_stat(s)

static func _equip_ability(ability_name: StringName) -> Callable:
	return func() -> void: GlobalStats.equip_ability(ability_name)

static func get_upgrade(internal_name: String) -> UpgradeData:
	return UpgradeRegistry.get_by_name(internal_name)

# static func get_randomized_augmented_upgrades(type: Array[String], amount: int) -> Array[UpgradeData]:
# 	var random_sample : Array[UpgradeData] = get_randomized_upgrades(type, amount)
# 	var augmented_sample : Array[UpgradeData] = []
# 	for upgrade: UpgradeData in random_sample:
# 		augmented_sample.append(upgrade.with_augment_cost())
# 	return augmented_sample


# static func get_randomized_upgrades(type: Array[String], amount: int, do_upgrade : bool = true) -> Array[UpgradeData]:
# 	var chosen_upgrades : Array[UpgradeData] = UpgradePicker.pick(type, amount)
# 	if not do_upgrade:
# 		return chosen_upgrades

# 	var new_upgrades : Array[UpgradeData] = []
# 	var cursed : bool = false
# 	for upgrade: UpgradeData in chosen_upgrades:
# 		if upgrade.blessing_type == UpgradePool.BIG_CURSE:
# 			TutorialManager.show_tutorial(TutorialManager.TutorialEnum.BELUGAS_BLESSING)
# 			new_upgrades.append(upgrade.with_beluga_blessing())
# 		else:
# 			var rand_val : float = randf()
# 			if rand_val < 0.15 and not cursed:
# 				TutorialManager.show_tutorial(TutorialManager.TutorialEnum.ANGLERS_CURSE)
# 				new_upgrades.append(upgrade.with_angler_curse())
# 				cursed = true
# 			else:
# 				new_upgrades.append(upgrade)
# 	return new_upgrades


#------ UPGRADE CALLABLES -------- #
static func after_n_games(post_game_stats: Dictionary, n: int) -> bool:
	## ok post_game_stats right now is life time stats, but im sure this can be current_run_stats
	# but i guess thats also globally accessible (but not guarantee to still exist)
	return GameData.get_stat("games_played") >= n

# static func after_n_wins(post_game_stats: Dictionary, n: int) -> bool:
# 	## ok post_game_stats right now is life time stats, but im sure this can be current_run_stats
# 	# but i guess thats also globally accessible (but not guarantee to still exist)
# 	return GameData.get_stat("boss_defeats") >= n

		

# ------- DESCRIPTION FUNCTIONS -------
static func _heal_desc() -> String:
	return "Take some time! Increase every time you choose it!"

static func _damage_desc() -> String:
	return "Lose some time! Increase every time you choose it!"

static func _xp_suck_desc() -> String:
	return "Orbs are attracted to you!"

static func _hop_skip_jump_desc() -> String:
	if GlobalStats.current_run_stats["bigger_attack_every_n_hits"] == 0:
		return "Every 5 hits, your attack hits a larger area!"
	else:
		return "Every %d hits, your attack hits an even larger area!" % StatCalculator.get_bigger_attack_every_n_hits(true)
# static func _enemy_xp_drop_desc() -> String:
# 	if GlobalStats.current_run_stats["enemy_xp_drop"] == 0:
# 		return "Enemies have a chance to drop extra time orbs!"
# 	else:
# 		return "Enemies have a chance to drop even more time orbs!"

static func _whale_desc() -> String:
	return "Call Beluga to attack enemies!"
	

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
	return "Time ticks faster... Gain %d max health." % 10

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
	return "Gain ebb when you have less than %d health!" % StatCalculator.get_dying_ebb(true)


## boss zone

static func _boss_freeze_desc() -> String:
	return "Freeze time for %d seconds" % StatCalculator.get_boss_freeze_time(true)

static func _decaying_touch_desc() -> String:
	return "Decay when you take damage."

static func _num_whales_desc() -> String:
	return "Summon an extra whale when you call Beluga!"

static func _extra_boss_health_desc() -> String:
	return "Increase boss health!"

static func _critical_damage_desc() -> String:
	return "Your attacks can critically strike (25%%) for %d damage!" % StatCalculator.get_critical_damage(true)

static func _boss_xp_drop_desc() -> String:
	return "Boss drops %d time orbs when damaged!" % StatCalculator.get_boss_xp_drop_per_hit(true)

static func _boss_attack_size_desc() -> String:
	return "Boss signature attack hits a larger area!"

static func _dash_cooldown_reduction_desc() -> String:
	return "Dash recharges faster, but you move slower."

static func _dash_cooldown_increase_desc() -> String:
	return "You move faster, but your dash charges slower."

static func _suicide_dash_desc() -> String:
	return "Dash recharges much faster, but each dash costs 1 health."

static func _dash_reset_on_damage_desc() -> String:
	return "Taking damage instantly resets your dash."

static func _dash_damages_status_desc() -> String:
	return "Your dash deals 1 damage to enemies with a status effect."

static func _beluga_orb_drop_desc() -> String:
	return "Beluga kills drop %d time orbs!" % StatCalculator.orbs_on_beluga_kill(true)

static func _beluga_cd_refund_desc() -> String:
	var refund : float = StatCalculator.on_beluga_kill_cd_refund_percent(true) * 100.0
	return "Beluga kills refund %.0f%% of its remaining cooldown!" % refund

static func _beluga_freeze_desc() -> String:
	var t : float = StatCalculator.beluga_freeze_time(true)
	return "Casting Beluga freezes time for %.0fs! Cooldown increases by the same amount x1.5." % t

static func _midas_dash_touch_desc() -> String:
	var num_orbs : int = StatCalculator.get_midas_dash_touch_num(true)
	return "Dashing through an enemy has a chance to drop %d time orb!" % num_orbs

static func _jump_kill_orb_desc() -> String:
	var num_orbs : int = StatCalculator.get_jump_kill_orb_num(true)
	return "Kills from your jump have a chance to drop %d time orb!" % num_orbs
