extends Node3D

class_name WhaleSpawner
@export var whale : Whale
var cooldown : float = 4.5
var cooldown_timer : float = 0.0

var player : CharacterBody3D
var floor : FloorNav
var enemy_spawner : EnemySpawner

func setup(player_ : CharacterBody3D, floor_ : FloorNav, enemy_spawner_ : EnemySpawner) -> void:
	self.player = player_
	self.floor = floor_
	self.enemy_spawner = enemy_spawner_


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spawn_whale"):
		if can_cast():	
			cast_whale()

func _process(delta: float) -> void:
	if cooldown_timer > 0.0:
		cooldown_timer -= delta
		if cooldown_timer < 0.0:
			cooldown_timer = 0.0


func play_whale() -> void:
	whale.visible = true
	whale.play()
	await whale.whale_animation_player.animation_finished
	whale.visible = false

func can_cast() -> bool:
	return GlobalStats.has_beluga() and cooldown_timer <= 0.0

func cast_whale() -> void:
	cooldown_timer = cooldown
	var enemies : Array[Node3D] = enemy_spawner.get_alive_enemies()
	whale.global_transform.origin = get_spawn_location(enemies)
	whale.scale = Vector3.ONE * GlobalStats.get_whale_size()
	play_whale()

func get_cooldown_progress() -> float:
	return 1.0 - (cooldown_timer / cooldown)


func get_spawn_location(enemies : Array[Node3D]) -> Vector3:
	if enemies.size() == 0:
		return player.global_transform.origin
	
	## choose enemy closest to player
	var closest_enemy : Node3D = enemies[0]
	var closest_distance : float = player.global_transform.origin.distance_to(closest_enemy.global_transform.origin)
	for enemy in enemies:
		var distance : float = player.global_transform.origin.distance_to(enemy.global_transform.origin)
		if distance < closest_distance:
			closest_enemy = enemy
			closest_distance = distance
	var spawn_location : Vector3 = closest_enemy.global_transform.origin

	var map : AABB = floor.get_bounds()
	var radius :float = 1.5 * GlobalStats.get_whale_size()
	spawn_location.x = clamp(spawn_location.x, map.position.x + radius, map.position.x + map.size.x - radius)
	spawn_location.y = 0
	spawn_location.z = clamp(spawn_location.z, map.position.z + radius, map.position.z + map.size.z - radius)

	return spawn_location
