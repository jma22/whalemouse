extends Node3D

class_name WhaleSpawner
# @export var whale : Whale
var base_cooldown : float = 5.0
var cooldown_timer : float = 0.0

var player : CharacterBody3D
var floor : FloorNav
var enemy_spawner : EnemySpawner
var camera : Camera3D
var whale_scene : PackedScene = preload("res://Player/Abilities/Whale/whale.tscn")

func setup(player_ : CharacterBody3D, camera_ : Camera3D) -> void:
	self.player = player_
	self.camera = camera_

func enter_map(map : MapManagerBase) -> void:
	self.floor = map.floor
	self.enemy_spawner = map.enemy_spawner


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spawn_whale"):
		if can_cast():	
			cast_whale()

func _process(delta: float) -> void:
	if cooldown_timer > 0.0:
		cooldown_timer -= delta
		if cooldown_timer < 0.0:
			cooldown_timer = 0.0


func play_whale(whale : Whale) -> void:
	whale.visible = true
	whale.play(self)
	await whale.whale_animation_player.animation_finished
	whale.visible = false
	whale.queue_free()

func can_cast() -> bool:
	return GlobalStats.has_beluga() and cooldown_timer <= 0.0

func cast_whale() -> void:
	cooldown_timer = get_cooldown()
	var enemies : Array[Node3D]
	if enemy_spawner != null:
		enemies = enemy_spawner.get_alive_enemies()
	else:
		enemies = []
	print("num_enemies: " + str(enemies.size()))
	var spawn_locations : Array[Vector3] = get_spawn_location(enemies, GlobalStats.get_num_whales())
	for spawn_location in spawn_locations:
		var whale_instance : Whale = whale_scene.instantiate() as Whale
		add_child(whale_instance)
		whale_instance.global_transform.origin = spawn_location
		whale_instance.scale = Vector3.ONE * GlobalStats.get_whale_size()
		play_whale(whale_instance)


func camera_shake_callback() -> void:
	if GlobalStats.current_run_stats["whale_level"] >= 3:
		camera.camera_shake(1.0, 0.2)
		



func get_cooldown_progress() -> float:
	return 1.0 - (cooldown_timer / get_cooldown())

func get_spawn_location(enemies : Array[Node3D], topk :int = 1) -> Array[Vector3]:
	var ans : Array[Vector3] = []
	if enemies.size() == 0:
		# for i in range(topk):
		# 	ans.append(player.global_transform.origin)
		return [player.global_transform.origin]
	
	## choose enemy closest to player
	var enemy_distance : Array = []
	for enemy in enemies:
		var distance : float = player.global_transform.origin.distance_to(enemy.global_transform.origin)
		enemy_distance.append({"enemy": enemy, "distance": distance})
	enemy_distance.sort_custom(func(a : Dictionary, b : Dictionary) -> bool: return a["distance"] < b["distance"])

	# var closest_enemy : Node3D = enemies[0]
	# var closest_distance : float = player.global_transform.origin.distance_to(closest_enemy.global_transform.origin)
	# for enemy in enemies:
	# 	var distance : float = player.global_transform.origin.distance_to(enemy.global_transform.origin)
	# 	if distance < closest_distance:
	# 		closest_enemy = enemy
	# 		closest_distance = distance
	var radius :float = 1.5 * GlobalStats.get_whale_size()

	for i in range(min(topk, enemies.size())):
		var closest_enemy : Node3D = enemy_distance[i]["enemy"]
		var spawn_location : Vector3 = closest_enemy.global_transform.origin
		spawn_location = floor.clamp_position(spawn_location, radius)
		ans.append(spawn_location)
	return ans

func get_cooldown() -> float:
	return max(base_cooldown * (1.0 - GlobalStats.get_whale_cooldown()), 0.5)
