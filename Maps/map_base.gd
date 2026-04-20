@abstract
extends Node3D
class_name MapManagerBase

@export var gateway : Gateway
@warning_ignore("shadowed_global_identifier")
@export var floor : NavigationRegion3D 
@export var player_spawn_point : Node3D

var player : CharacterBody3D
var map_cleared_flag : bool = false
var wave_info : WaveInfo
var camera : Camera3D

var room_active : bool = false

func setup(player : CharacterBody3D, camera : Camera3D, hud : HUD) -> void:
	self.player = player
	self.camera = camera
	self.camera.set_bounds(floor.get_bounds())
	floor.setup(player, camera)
	gateway.setup(self)
	room_active = false


func _process(delta: float) -> void:
	if not room_active:
		return
	if not map_cleared_flag and map_cleared():
		map_cleared_flag = true
		on_map_cleared()

func start_room(wave_info_ : WaveInfo) -> void:
	player.clear_effects()
	self.camera.set_wave_mode()
	map_cleared_flag = false
	player.global_transform.origin = player_spawn_point.global_transform.origin
	gateway.close_gateway()
	wave_info = wave_info_
	room_active = true


@abstract
func map_cleared() -> bool


func on_map_cleared() -> void:
	gateway.open_gateway()

func leave_room() -> void:
	room_active = false
