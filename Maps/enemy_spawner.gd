extends Node3D
class_name EnemySpawner

# const enemy_string_to_scene = {
# 	"DashEnemy": preload("res://Enemies/lunging_enemy/enemy.tscn"),
# 	"FloatEnemy": preload("res://Enemies/floating_enemy/enemy2.tscn"),
# 	# "SquidMinion": preload("res://Enemies/SquidMinion/squid_minion.tscn"),
# 	# "SquidBoss": preload("res://Enemies/SquidBoss/squid_boss.tscn"),
# 	"Barnacle": preload("res://Enemies/Barnacle/barnacle.tscn"),
# 	"ShootingEnemy": preload("res://Enemies/shooting_enemy/shooting_enemy.tscn"),
# 	"AuraEnemy": preload("res://Enemies/aura_enemy/aura_enemy.tscn"),
# 	"JumpingEnemy": preload("res://Enemies/jumping_enemy/jumping_enemy.tscn"),
# 	"LobbingEnemy": preload("res://Enemies/lobbing_enemy/lobbing_enemy.tscn"),
# }

const enemy_data = {
	"DashingEnemy": {
		"scene": preload("res://Enemies/lunging_enemy/enemy.tscn"),
		"cost": 3,
		"max_per_wave": 3,
		"min_depth": 2,
		"spawn_type" : "melee",
		"name": "Piranha",
	},
	"FloatingEnemy": {
		"scene": preload("res://Enemies/floating_enemy/enemy2.tscn"),
		"cost": 2,
		"max_per_wave": 4,
		"min_depth": 0,
		"spawn_type": "any",
		"name": "Floaty",
	},
	"Barnacle": {
		"scene": preload("res://Enemies/Barnacle/barnacle.tscn"),
		"cost": 3,
		"max_per_wave": 5,
		"min_depth": 1,
		"spawn_type" : "melee",
		"name": "Barnacle",
	},
	"ShootingEnemy": {
		"scene": preload("res://Enemies/shooting_enemy/shooting_enemy.tscn"),
		"cost": 4,
		"max_per_wave": 2,
		"min_depth": 1,
		"spawn_type" : "ranged",
		"name": "Spit",
	},
	"AuraEnemy": {
		"scene": preload("res://Enemies/aura_enemy/aura_enemy.tscn"),
		"cost": 4,
		"max_per_wave": 2,
		"min_depth": 3,
		"spawn_type": "any",
		"name": "Electric",
	},
	"JumpingEnemy": {
		"scene": preload("res://Enemies/jumping_enemy/jumping_enemy.tscn"),
		"cost": 5,
		"max_per_wave": 3,
		"min_depth": 3,
		"spawn_type": "melee",
		"name": "Skwid",
	},
	"LobbingEnemy": {
		"scene": preload("res://Enemies/lobbing_enemy/lobbing_enemy.tscn"),
		"cost": 4,
		"max_per_wave": 2,
		"min_depth": 2,
		"spawn_type": "ranged",
		"name": "Tosser",
	},
	"AnglerEye": {
		"scene": preload("res://Enemies/AnglerBoss/AnglerEye/angler_eye.tscn"),
		"cost": 99,
		"max_per_wave": 2,
		"min_depth": 99,
		"spawn_type": "ranged",
		"name": "AnglerEye",
	},
	"Angler" :{
		"scene": preload("res://Enemies/AnglerBoss/angler_boss.tscn"),
		"cost": 99,
		"max_per_wave": 2,
		"min_depth": 99,
		"spawn_type": "ranged",
		"name": "AnglerEye",
	},
	"AnglerPillar" : {
		"scene": preload("res://Enemies/AnglerBoss/Pillar/angler_pillar.tscn"),
		"cost": 99,
		"max_per_wave": 2,
		"min_depth": 99,
		"spawn_type": "melee",
		"name": "AnglerPillar",
	},
	"SquidMinion": {
		"scene": preload("res://Enemies/SquidMinion/squid_minion.tscn"),
		"cost": 1,
		"max_per_wave": 4,
		"min_depth": 1,
		"spawn_type": "any",
		"name": "Squid Minion",
	},
}

var spawned_enemies : Array[Node3D] = []
var spawn_freq : float = 1.0
var spawn_timer : float = 0.0

var num_enemies_to_spawn : int = 0
var player : CharacterBody3D
var floor : NavigationRegion3D

var boss_health : BossHealth
var camera : Camera3D


func setup(player : CharacterBody3D, floor : NavigationRegion3D, boss_health : BossHealth, camera : Camera3D) -> void:
	self.player = player
	self.floor = floor
	self.boss_health = boss_health
	self.camera = camera
	clear_enemies()
	


# func _process(delta: float) -> void:
	# super(delta)
	# spawn_timer += delta
	# if spawn_timer >= spawn_freq:
	# 	spawn_timer = 0.0
	# 	check_to_spawn_more()

# func start_room (wave_info_ : WaveInfo) -> void:
# 	super(wave_info_)
# 	clear_enemies()
# 	spawn_enemies(wave_info.enemies_to_spawn, false)
# 	player.clear_effects()

static func sample_unlockable_enemy(current_wave : int, unlocked_enemies : Array[String]) -> String:
	var unlockable_enemies : Array[String] = []
	for enemy_name : String in enemy_data.keys():
		if current_wave >= enemy_data[enemy_name].min_depth * 5 and not enemy_name in unlocked_enemies:
			unlockable_enemies.append(enemy_name)
	
	if unlockable_enemies.size() == 0:
		return ""
	unlockable_enemies.shuffle()	
	return unlockable_enemies[0]

static func get_enemy_data(enemy_name : String) -> Dictionary:
	if enemy_name in enemy_data:
		return enemy_data[enemy_name]
	else:
		printerr("Enemy %s not found in enemy data!" % enemy_name)
		return {}

func set_wave_spawning(wave_info : WaveInfo, _wave_map_manager : MapManagerBase) -> void:
	var enemies_to_spawn : Array[String] = build_wave(wave_info.enemy_budget, wave_info.enemy_pool, wave_info.wave_number)
	var spawn_pools : Dictionary[String,ShuffledPool] = _wave_map_manager.get_spawn_pools()

	for enemy : String in enemies_to_spawn:
		var spawn_type : String = enemy_data[enemy].spawn_type
		var point : Node3D = spawn_pools[spawn_type].next()
		var enemy_node : Node3D = spawn_enemy(enemy, point.global_position)
		if enemy_node is EnemyBase:
			for effect_name : String in sample_status_effects():
				var effect : StatusEffectBase = StatusEffectFactory.make(effect_name)
				if effect is EnemyStatusEffect:
					(enemy_node as EnemyBase).gain_status_effect(effect, self)


func sample_status_effects() -> Array[String]:
	## sample from statcalculator
	var possible_effects : Array[String] = [StatusEffectNames.EBBY, StatusEffectNames.WITHER, StatusEffectNames.POISON, StatusEffectNames.MARK, StatusEffectNames.SHIELDED, StatusEffectNames.SLIPPERY, StatusEffectNames.SPIKEY, StatusEffectNames.CURSED, StatusEffectNames.BERSERK, StatusEffectNames.INFESTED]
	var chosen_effects : Array[String] = []
	for effect in possible_effects:
		var chance : float = 0.0 + StatCalculator.get_chance_for_effect(effect)
		if chance == 0.0:
			continue
		if randf() < chance:
			chosen_effects.append(effect)
	return chosen_effects

func build_wave(budget: int, pool: Array[String], current_wave : int) -> Array[String]:
	var result: Array[String] = []
	var remaining: int = budget
	var counts: Dictionary = {}

	var available: Array[String] = get_affordable_enemies(pool, remaining, counts, current_wave)

	while not available.is_empty() and remaining > 0:
		var pick: String = available.pick_random()

		result.append(pick)
		remaining -= int(enemy_data[pick].cost)
		counts[pick] = int(counts.get(pick, 0)) + 1

		available = get_affordable_enemies(pool, remaining, counts, current_wave)

	return result


func get_affordable_enemies(pool: Array[String], budget: int, counts: Dictionary, current_wave : int) -> Array[String]:
	var filtered: Array[String] = []
	for enemy : String in pool:
		var data: Dictionary = enemy_data[enemy]
		var can_afford: bool = int(data.cost) <= budget
		# var under_cap: bool = int(counts.get(enemy, 0)) < int(data.max_per_wave)
		var under_cap : bool = true
		var unlocked : bool = true
		# var unlocked: bool = current_wave >= int(data.min_depth)
		if can_afford and under_cap and unlocked:
			filtered.append(enemy)
	return filtered

func get_alive_enemies() -> Array[Node3D]:
	var non_dead_enemies : Array[Node3D] = []
	for enemy in spawned_enemies:
		print("checking enemy: ", enemy.name, " is_dead: ", enemy.is_dead)
		if not enemy.is_dead:
			# centroid = enemy.global_transform.origin
			non_dead_enemies.append(enemy)
	return non_dead_enemies


func clear_enemies() -> void:
	for enemy in spawned_enemies:
		enemy.queue_free()
	spawned_enemies.clear()

func spawner_done() -> bool:
	return len(spawned_enemies) >= num_enemies_to_spawn

func all_dead() -> bool:
	for enemy in spawned_enemies:
		if not enemy.is_dead:
			return false
	return true

func spawn_enemy(enemy_type: String, spawn_point : Vector3) -> Node3D:
	print("spawning enemy: " + enemy_type)
	if enemy_type in enemy_data:
		var enemy_scene : PackedScene = enemy_data[enemy_type].scene
		var enemy_instance : Node = enemy_scene.instantiate()
		add_child(enemy_instance)

		enemy_instance.global_transform.origin = spawn_point
		enemy_instance.global_transform.origin.y = 0
		enemy_instance.setup(player, floor)
		spawned_enemies.append(enemy_instance)
		return enemy_instance
	return null

func spawn_boss(enemy_type: String, spawn_point : Vector3) -> Node3D:
	if enemy_type in enemy_data:
		var enemy_scene : PackedScene = enemy_data[enemy_type].scene
		var enemy_instance : Node = enemy_scene.instantiate()
		add_child(enemy_instance)

		enemy_instance.global_transform.origin = spawn_point
		enemy_instance.link_boss_health(boss_health)
		enemy_instance.link_spawner(self)
		enemy_instance.link_camera(camera)
		enemy_instance.setup(player, floor)
		# spawned_enemies.append(enemy_instance)
		return enemy_instance
	return null

func kill_all_enemies() -> void:
	for enemy in spawned_enemies:
		enemy.on_die(null)
	spawned_enemies.clear()
