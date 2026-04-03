extends Node3D
class_name MapManager

const enemy_string_to_scene = {
	"enemy1": preload("res://Enemies/lunging_enemy/enemy.tscn"),
	"enemy2": preload("res://Enemies/floating_enemy/enemy2.tscn"),
}
# @export var player_spawn_point: Node3D
@export var enemy_spawn_points: Array[Node3D]
@export var floor : NavigationRegion3D 
@export var gateway : Gateway

var player : CharacterBody3D
var spawned_enemies : Array[Node3D] = []
var spawn_freq : float = 1.0
var spawn_timer : float = 0.0
var wave_info : WaveInfo

var map_cleared_flag : bool = false




func setup(player : CharacterBody3D, camera : Camera3D) -> void:
	clear_enemies()
	self.player = player
	camera.set_bounds(floor.get_bounds())
	floor.setup(player, camera)

func _process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer >= spawn_freq:
		spawn_timer = 0.0
		check_to_spawn_more()

	if not map_cleared_flag and map_cleared():
		map_cleared_flag = true
		gateway.open_gateway()
		
func start_room (wave_info_ : WaveInfo) -> void:
	wave_info = wave_info_
	print("Starting room with wave info: ", wave_info)
	clear_enemies()
	spawn_enemies(wave_info.enemies_to_spawn, false)
	gateway.close_gateway()
	map_cleared_flag = false

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

func get_enemy_centroid() -> Vector3:
	var centroid : Vector3 = Vector3.ZERO
	var non_dead_enemies : Array[Node3D] = []
	for enemy in spawned_enemies:
		if not enemy.is_dead:
			centroid = enemy.global_transform.origin
			non_dead_enemies.append(enemy)
	
	if non_dead_enemies.size() == 0:
		return player.global_transform.origin
	
	## choose enemy closest to player
	var closest_enemy : Node3D = non_dead_enemies[0]
	var closest_distance : float = player.global_transform.origin.distance_to(closest_enemy.global_transform.origin)
	for enemy in non_dead_enemies:
		var distance : float = player.global_transform.origin.distance_to(enemy.global_transform.origin)
		if distance < closest_distance:
			closest_enemy = enemy
			closest_distance = distance
	centroid = closest_enemy.global_transform.origin
	# centroid = centroid / spawned_enemies.size()

	var map : AABB = floor.get_bounds()
	var radius :float = 1.5 * GlobalStats.get_whale_size()
	centroid.x = clamp(centroid.x, map.position.x + radius, map.position.x + map.size.x - radius)
	centroid.y = 0
	centroid.z = clamp(centroid.z, map.position.z + radius, map.position.z + map.size.z - radius)

	return centroid

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
