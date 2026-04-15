extends MapManagerBase
@export var enemy_spawner : EnemySpawner

# @export var shrines : Array[Node3D]


func setup(player : CharacterBody3D, camera : Camera3D, hud : HUD) -> void:
	super(player, camera, hud)
	enemy_spawner.setup(player, floor, hud.boss_health)

func start_room (wave_info_ : WaveInfo) -> void:
	# super(wave_info_)
	# enemy_spawner.set_wave_spawning(wave_info_)
	# enemy_spawner.spawn_boss("SquidBoss", Vector3(0,0,0))

	for i in range(1):
		enemy_spawner.spawn_enemy("enemy1", Vector3(1,0,0))


func map_cleared() -> bool:
	# for shrine : Shrine in shrines:
	# 	if shrine and shrine.activated:
	# 		return true
	return false

# func on_map_cleared() -> void:
# 	super()
	# for shrine : Shrine in shrines:
	# 	shrine.close_gateway()


# func spawn_enemy(enemy_type: String, spawn_point : Vector3) -> void:
# 	if enemy_type in enemy_string_to_scene:
# 		var enemy_scene = enemy_string_to_scene[enemy_type]
# 		var enemy_instance = enemy_scene.instantiate()
# 		add_child(enemy_instance)
# 		enemy_instance.global_transform.origin = spawn_point
# 		enemy_instance.setup(player, floor)
