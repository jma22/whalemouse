extends Node3D


@onready var player : CharacterBody3D = $Player
@onready var hud : HUD = $HUD
@onready var map : MapManagerBase = $Map
@onready var camera : Camera3D = $Camera3D
@onready var whale_spawner : WhaleSpawner = $WhaleSpawner

# @export var enemy : EnemyBase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.reset()
	player.setup(hud,camera)
	GlobalStats.reset_current_run_stats()
	GlobalStats.setup(player, hud)
	hud.setup(player)
	map.setup(player,camera, hud)
	# enemy.setup(player, map.floor)
	whale_spawner.setup(player)
	map.start_room(null)

	# GlobalStats.add_to_stat("dash_distance")
	# GlobalStats.add_to_stat("whale_level")
	# for i in range(5):
	# 	GlobalStats.add_to_stat("player_attack_speed")

	
