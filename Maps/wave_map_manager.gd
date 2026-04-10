extends MapManagerBase
class_name WaveMapManager

const enemy_string_to_scene = {
	"enemy1": preload("res://Enemies/lunging_enemy/enemy.tscn"),
	"enemy2": preload("res://Enemies/floating_enemy/enemy2.tscn"),
	"SquidMinion": preload("res://Enemies/SquidMinion/squid_minion.tscn")
}
@export var enemy_spawn_points: Array[Node3D]

var spawned_enemies : Array[Node3D] = []
var spawn_freq : float = 1.0
var spawn_timer : float = 0.0



func setup(player : CharacterBody3D, camera : Camera3D) -> void:
	super(player, camera)
	clear_enemies()


func _process(delta: float) -> void:
	super(delta)
	spawn_timer += delta
	if spawn_timer >= spawn_freq:
		spawn_timer = 0.0
		check_to_spawn_more()

func start_room (wave_info_ : WaveInfo) -> void:
	super(wave_info_)
	clear_enemies()
	spawn_enemies(wave_info.enemies_to_spawn, false)


func check_to_spawn_more() -> void:
	if wave_info and len(spawned_enemies) < wave_info.enemies_to_spawn:
		spawn_enemies(1, true)

func spawn_enemies(enemies_to_spawn: int, random_spot : bool) -> void:
	for i in range(enemies_to_spawn):
		var enemy_spawn_point : Node3D
		if random_spot:
			enemy_spawn_point = enemy_spawn_points[randi() % enemy_spawn_points.size()]
		else:
			enemy_spawn_point = enemy_spawn_points[i % enemy_spawn_points.size()]
		var enemy_type :String = "enemy2" if randf() < 0.5 else "enemy1"
		if enemy_type in enemy_string_to_scene:
			var enemy_scene = enemy_string_to_scene[enemy_type]
			var enemy_instance = enemy_scene.instantiate()
			add_child(enemy_instance)
			enemy_instance.global_transform = enemy_spawn_point.global_transform
			# print("Spawning enemy of type: ", enemy_type , " at position: ", enemy_spawn_point.global_transform.origin)
			enemy_instance.setup(player, floor)
			spawned_enemies.append(enemy_instance)


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

func map_cleared() -> bool:
	if wave_info and len(spawned_enemies) < wave_info.enemies_to_spawn:
		return false

	for enemy in spawned_enemies:
		if not enemy.is_dead:
			return false
	return true

func spawn_enemy(enemy_type: String, spawn_point : Vector3) -> void:
	if enemy_type in enemy_string_to_scene:
		var enemy_scene = enemy_string_to_scene[enemy_type]
		var enemy_instance = enemy_scene.instantiate()
		add_child(enemy_instance)
		enemy_instance.global_transform.origin = spawn_point
		enemy_instance.setup(player, floor)
		spawned_enemies.append(enemy_instance)
