extends Node3D
class_name Ability

var player : CharacterBody3D
var camera : Camera3D
var floor : FloorNav
var enemy_spawner : EnemySpawner  # can be null

func cast() -> void:
	pass

func get_cooldown() -> float:
	return 5.0

func setup(player_ : CharacterBody3D, camera_ : Camera3D) -> void:
	self.player = player_
	self.camera = camera_

func enter_map(map : MapManagerBase) -> void:
	self.floor = map.floor
	if map.enemy_spawner != null:
		self.enemy_spawner = map.enemy_spawner
