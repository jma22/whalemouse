extends Node3D
class_name MapManager

const enemy_string_to_scene = {
	"enemy1": preload("res://Enemies/lunging_enemy/enemy.tscn"),
	"enemy2": preload("res://Enemies/floating_enemy/enemy2.tscn"),
}
# @export var player_spawn_point: Node3D
@export var enemy_spawn_points: Array[Node3D]
@export var map : NavigationRegion3D 
@export var gateway : Gateway

var player : CharacterBody3D
var spawned_enemies : Array[Node3D] = []

func setup(player : CharacterBody3D, camera : Camera3D) -> void:
	clear_enemies()
	self.player = player
	camera.set_bounds(map.get_bounds())

func _process(delta: float) -> void:
	if map_cleared():
		gateway.open_gateway()
		
func start_room (wave_info : WaveInfo) -> void:
	print("Starting room with wave info: ", wave_info)
	clear_enemies()
	spawn_enemies()
	gateway.close_gateway()

func spawn_enemies() -> void:
	for enemy_spawn_point in enemy_spawn_points:
		var enemy_type :String = "enemy2" if randf() < 0.5 else "enemy1"
		if enemy_type in enemy_string_to_scene:
			var enemy_scene = enemy_string_to_scene[enemy_type]
			var enemy_instance = enemy_scene.instantiate()
			add_child(enemy_instance)
			enemy_instance.global_transform = enemy_spawn_point.global_transform
			print("Spawning enemy of type: ", enemy_type , " at position: ", enemy_spawn_point.global_transform.origin)
			enemy_instance.setup(player, map)
			spawned_enemies.append(enemy_instance)

func clear_enemies() -> void:
	for enemy in spawned_enemies:
		enemy.queue_free()
	spawned_enemies.clear()

func map_cleared() -> bool:
	for enemy in spawned_enemies:
		if not enemy.is_dead:
			return false
	return true
