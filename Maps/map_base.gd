@abstract
extends Node3D
class_name MapManagerBase

@export var gateway : Gateway
@export var floor : NavigationRegion3D 
@export var player_spawn_point : Node3D



var player : CharacterBody3D
var map_cleared_flag : bool = false
var wave_info : WaveInfo

func setup(player : CharacterBody3D, camera : Camera3D) -> void:
	self.player = player
	camera.set_bounds(floor.get_bounds())
	floor.setup(player, camera)

func _process(delta: float) -> void:
	if not map_cleared_flag and map_cleared():
		map_cleared_flag = true
		on_map_cleared()

func start_room(wave_info_ : WaveInfo) -> void:
	map_cleared_flag = false
	player.global_transform.origin = player_spawn_point.global_transform.origin
	gateway.close_gateway()
	wave_info = wave_info_


@abstract
func map_cleared() -> bool

func on_map_cleared() -> void:
	gateway.open_gateway()
