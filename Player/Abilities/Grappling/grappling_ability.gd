extends Ability

class_name GrapplingAbility
# @export var whale : Whale
var base_cooldown : float = 5.0

# var shooter_scene : PackedScene = load("res://Player/Abilities/HomingMissiles/projectile_shooter.tscn")
# var shooter_instance : ProjectileShooter = null

# func setup(player_ : CharacterBody3D, camera_ : Camera3D) -> void:
# 	super(player_, camera_)
# 	DebugLog.dbg_from(self,"HomingAbility setup")
# 	shooter_instance = shooter_scene.instantiate() as ProjectileShooter
# 	add_child(shooter_instance)
# 	shooter_instance.setup(player)
	# var shooter_instance : ProjectileShooter = shooter_scene.instantiate() as ProjectileShooter
	# 	add_child(shooter_instance)
	# 	shooter_instance.setup(player)
	




# func _input(event: InputEvent) -> void:
# 	if event.is_action_pressed("spawn_whale"):
# 		if can_cast():	
# 			cast_whale()

# func _process(delta: float) -> void:
# 	if cooldown_timer > 0.0:
# 		cooldown_timer -= delta
# 		if cooldown_timer < 0.0:
# 			cooldown_timer = 0.0
# 	if StatCalculator.beluga_auto_cast() and can_cast():
# 		DebugLog.dbg_from(self,"auto-casting whale because of beluga_auto_cast")
# 		# if not (player as Player).status_effect_manager.has_status_effect(StatusEffectNames.FREEZE):
# 		cast_whale()

# func _process(delta: float) -> void:
# 	shooter_instance.tick(delta)


func cast() -> void:
	# cooldown_timer = get_cooldown()
	# if StatCalculator.beluga_freeze_time() > 0.0:
	# 	(player as Player).gain_status_effect(FreezeEffect.make(StatCalculator.beluga_freeze_time()), self)
	# 	DebugLog.dbg_from(self,"beluga_freeze → applied Freeze to player (duration=%.1fs)" % StatCalculator.beluga_freeze_time())
	
	var enemies : Array[Node3D]
	if enemy_spawner != null:
		enemies = enemy_spawner.get_alive_enemies()
	else:
		enemies = []
	# # var num_whales : int = StatCalculator.get_num_whales()
	# # var whale_size : float = StatCalculator.get_whale_size()
	enemies = get_topk_closest(enemies, 1)
	# DebugLog.dbg_from(self,"cast homing missiles on %s nearby enemies" % [enemies.size()])
	# # for enemy in enemies:
	# shooter_instance.start_burst(Vector3.FORWARD, enemies[0])
	player.grapple_state.set_target(enemies[0])
	player.state_machine.set_state(player.grapple_state)
		


# func camera_shake_callback() -> void:
# 	if GlobalStats.current_run_stats["whale_size"] >= 35:
# 		camera.camera_shake(1.0, 0.2)


func get_topk_closest(enemies : Array[Node3D], topk :int = 1) -> Array[Node3D]:
	var ans : Array[Node3D] = []
	if enemies.size() == 0:
		# for i in range(topk):
		# 	ans.append(player.global_transform.origin)
		return []
	
	## choose enemy closest to player
	var enemy_distance : Array = []
	for enemy in enemies:
		var distance : float = player.global_transform.origin.distance_to(enemy.global_transform.origin)
		enemy_distance.append({"enemy": enemy, "distance": distance})
	enemy_distance.sort_custom(func(a : Dictionary, b : Dictionary) -> bool: return a["distance"] < b["distance"])

	for i in range(min(topk, enemies.size())):
		var closest_enemy : Node3D = enemy_distance[i]["enemy"]
		ans.append(closest_enemy)

	return ans

func get_cooldown() -> float:
	return max(base_cooldown * StatCalculator.get_whale_cooldown_reduction(), 1.0)
