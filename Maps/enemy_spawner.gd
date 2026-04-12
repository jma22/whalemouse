extends Node3D
class_name EnemySpawner

const enemy_string_to_scene = {
	"enemy1": preload("res://Enemies/lunging_enemy/enemy.tscn"),
	"enemy2": preload("res://Enemies/floating_enemy/enemy2.tscn"),
	"SquidMinion": preload("res://Enemies/SquidMinion/squid_minion.tscn"),
	"SquidBoss": preload("res://Enemies/SquidBoss/squid_boss.tscn")
}
@export var enemy_spawn_points: Array[Node3D]

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
	


func _process(delta: float) -> void:
	# super(delta)
	spawn_timer += delta
	if spawn_timer >= spawn_freq:
		spawn_timer = 0.0
		check_to_spawn_more()

# func start_room (wave_info_ : WaveInfo) -> void:
# 	super(wave_info_)
# 	clear_enemies()
# 	spawn_enemies(wave_info.enemies_to_spawn, false)
# 	player.clear_effects()

func set_wave_spawning(wave_info_ : WaveInfo) -> void:
	# wave_info = wave_info_
	num_enemies_to_spawn = wave_info_.enemies_to_spawn
	spawn_enemies(wave_info_.enemies_to_spawn, false)

func check_to_spawn_more() -> void:
	if not spawner_done():
		spawn_enemies(1, true)

func spawn_enemies(enemies_to_spawn: int, random_spot : bool) -> void:
	for i in range(enemies_to_spawn):
		var enemy_spawn_point : Node3D
		if random_spot:
			enemy_spawn_point = enemy_spawn_points[randi() % enemy_spawn_points.size()]
		else:
			enemy_spawn_point = enemy_spawn_points[i % enemy_spawn_points.size()]
		var enemy_type :String = "enemy2" if randf() < 0.5 else "enemy1"
		spawn_enemy(enemy_type, enemy_spawn_point.global_transform.origin)


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
	if enemy_type in enemy_string_to_scene:
		var enemy_scene : PackedScene = enemy_string_to_scene[enemy_type]
		var enemy_instance : Node = enemy_scene.instantiate()
		add_child(enemy_instance)
		enemy_instance.global_transform.origin = spawn_point
		enemy_instance.setup(player, floor)
		spawned_enemies.append(enemy_instance)

func spawn_boss(enemy_type: String, spawn_point : Vector3) -> void:
	if enemy_type in enemy_string_to_scene:
		var enemy_scene : PackedScene = enemy_string_to_scene[enemy_type]
		var enemy_instance : Node = enemy_scene.instantiate()
		add_child(enemy_instance)
		enemy_instance.global_transform.origin = spawn_point
		enemy_instance.setup(player, floor)
		enemy_instance.link_boss_health(boss_health)
		enemy_instance.link_spawner(self)
		spawned_enemies.append(enemy_instance)
