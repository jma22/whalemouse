extends Node3D

@export var map_manager: MapManager
@export var player : Node3D
@export var player_spawn_point: Node3D

@export var hud : HUD
@export var time_damage : TimeDamageManager


func _ready() -> void:
	setup()

func setup() -> void:
	player.global_transform.origin = Vector3.ZERO
	map_manager.setup(player)
	hud.setup(player)
	time_damage.setup(player)
	player.setup(hud)
