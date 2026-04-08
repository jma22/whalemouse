extends Node3D


@onready var player : CharacterBody3D = $Player
@onready var hud : HUD = $HUD
@onready var map : MapManagerBase = $Map
@onready var camera : Camera3D = $Camera3D
@onready var whale_spawner : WhaleSpawner = $WhaleSpawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.reset()
	player.setup(hud)
	GlobalStats.setup(player, hud)
	hud.setup(player)
	map.setup(player,camera)
	whale_spawner.setup(map)
	map.start_room(null)
	TutorialManager.enable_tutorials = false

	GlobalStats.add_to_stat("dash_distance")
	GlobalStats.add_to_stat("whale_level")

	
