<<<<<<< HEAD:map_manager.gd
extends Node3D
class_name MapManager
=======
extends Node
>>>>>>> 8e1ddb3c421010a4a25bbcf45a787f1c08073d74:scene_manager.gd

const enemy_string_to_scene = {
	"enemy1": preload("res://Enemies/enemy.tscn"),
	"enemy2": preload("res://Enemies/enemy2.tscn"),
}
# @export var player_spawn_point: Node3D
@export var enemy_spawn_points: Array[Node3D]
@export var map : NavigationRegion3D 

func setup(player : CharacterBody3D):
	for enemy_spawn_point in enemy_spawn_points:
		# var enemy_type = enemy_spawn_point.get("enemy_type")
		var enemy_type :String = "enemy1" 
		if enemy_type in enemy_string_to_scene:
			var enemy_scene = enemy_string_to_scene[enemy_type]
			var enemy_instance = enemy_scene.instantiate()
			enemy_instance.global_transform = enemy_spawn_point.global_transform
			enemy_instance.setup(player, map)
			add_child(enemy_instance)