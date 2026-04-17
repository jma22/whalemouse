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
	"DashEnemy": {
		"scene": preload("res://Enemies/lunging_enemy/enemy.tscn"),
		"cost": 2,
		"max_per_wave": 3,
		"min_depth": 0,
		"spawn_type" : "melee"
	},
	"FloatEnemy": {
		"scene": preload("res://Enemies/floating_enemy/enemy2.tscn"),
		"cost": 2,
		"max_per_wave": 4,
		"min_depth": 0,
		"spawn_type": "any"
	},
	"Barnacle": {
		"scene": preload("res://Enemies/Barnacle/barnacle.tscn"),
		"cost": 1,
		"max_per_wave": 5,
		"min_depth": 0,
		"spawn_type" : "melee"
	},
	"ShootingEnemy": {
		"scene": preload("res://Enemies/shooting_enemy/shooting_enemy.tscn"),
		"cost": 3,
		"max_per_wave": 2,
		"min_depth": 1,
		"spawn_type" : "ranged"
	},
	"AuraEnemy": {
		"scene": preload("res://Enemies/aura_enemy/aura_enemy.tscn"),
		"cost": 4,
		"max_per_wave": 2,
		"min_depth": 2,
		"spawn_type": "any"
	},
	"JumpingEnemy": {
		"scene": preload("res://Enemies/jumping_enemy/jumping_enemy.tscn"),
		"cost": 3,
		"max_per_wave": 3,
		"min_depth": 1,
		"spawn_type": "melee"

	},
	"LobbingEnemy": {
		"scene": preload("res://Enemies/lobbing_enemy/lobbing_enemy.tscn"),
		"cost": 4,
		"max_per_wave": 2,
		"min_depth": 2,
		"spawn_type": "ranged"
	},
}

var spawned_enemies : Array[Node3D] = []
var spawn_freq : float = 1.0
var spawn_timer : float = 0.0

var num_enemies_to_spawn : int = 0
var player : CharacterBody3D
var floor : NavigationRegion3D

var boss_health : BossHealth


func setup(player : CharacterBody3D, floor : NavigationRegion3D, boss_health : BossHealth) -> void:
	self.player = player
	self.floor = floor
	self.boss_health = boss_health
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

func set_wave_spawning(wave_info : WaveInfo, _wave_map_manager : MapManagerBase) -> void:
	var enemies_to_spawn : Array[String] = build_wave(wave_info.enemy_budget, wave_info.enemy_pool, wave_info.wave_number)
	var spawn_pools : Dictionary[String,ShuffledPool] = _wave_map_manager.get_spawn_pools()

	for enemy : String in enemies_to_spawn:
		var spawn_type : String = enemy_data[enemy].spawn_type
		var point : Node3D = spawn_pools[spawn_type].next()
		spawn_enemy(enemy, point.global_position)


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
	for enemy in pool:
		var data: Dictionary = enemy_data[enemy]
		var can_afford: bool = int(data.cost) <= budget
		# var under_cap: bool = int(counts.get(enemy, 0)) < int(data.max_per_wave)
		var under_cap : bool = true
		var unlocked: bool = current_wave >= int(data.min_depth)
		if can_afford and under_cap and unlocked:
			filtered.append(enemy)
	return filtered

func get_alive_enemies() -> Array[Node3D]:
	var non_dead_enemies : Array[Node3D] = []
	for enemy in spawned_enemies:
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

func spawn_enemy(enemy_type: String, spawn_point : Vector3) -> void:
	if enemy_type in enemy_data:
		var enemy_scene : PackedScene = enemy_data[enemy_type].scene
		var enemy_instance : Node = enemy_scene.instantiate()
		add_child(enemy_instance)
		enemy_instance.global_transform.origin = spawn_point
		enemy_instance.setup(player, floor)
		spawned_enemies.append(enemy_instance)

func spawn_boss(enemy_type: String, spawn_point : Vector3) -> void:
	if enemy_type in enemy_data:
		var enemy_scene : PackedScene = enemy_data[enemy_type].scene
		var enemy_instance : Node = enemy_scene.instantiate()
		add_child(enemy_instance)
		enemy_instance.global_transform.origin = spawn_point
		enemy_instance.setup(player, floor)
		enemy_instance.link_boss_health(boss_health)
		enemy_instance.link_spawner(self)
		spawned_enemies.append(enemy_instance)
