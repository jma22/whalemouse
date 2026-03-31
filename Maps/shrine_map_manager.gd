extends Node3D
class_name ShrineMapManager

# const enemy_string_to_scene = {
# 	"enemy1": preload("res://Enemies/lunging_enemy/enemy.tscn"),
# 	"enemy2": preload("res://Enemies/floating_enemy/enemy2.tscn"),
# }
# @export var player_spawn_point: Node3D
# @export var enemy_spawn_points: Array[Node3D]
@export var shrines : Array[Node3D]
@export var map : NavigationRegion3D 
@export var gateway : Gateway

var player : CharacterBody3D
var spawned_enemies : Array[Node3D] = []

func setup(player : CharacterBody3D, camera : Camera3D) -> void:
	self.player = player
	camera.set_bounds(map.get_bounds())

func _process(delta: float) -> void:
	if map_cleared():
		gateway.open_gateway()
		for shrine : Shrine in shrines:
			shrine.close_gateway()
		
func start_room (wave_info : WaveInfo) -> void:
	set_shrines(wave_info.blessings)
	gateway.close_gateway()

func set_shrines(blessings: Array[String]) -> void:
	for i in range(shrines.size()):
		shrines[i].setup(blessings[i])
		shrines[i].open_gateway()


func map_cleared() -> bool:
	for shrine : Shrine in shrines:
		if shrine and shrine.activated:
			return true
	return false
