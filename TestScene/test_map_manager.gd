extends MapManagerBase
@export var enemy_spawner : EnemySpawner
@export var ranged_spawns : Node3D
@export var melee_spawns : Node3D
@export var boss_spawn : Node3D
# @export var shrines : Array[Node3D]


func setup(player : CharacterBody3D, camera : Camera3D, hud : HUD) -> void:
	super(player, camera, hud)
	enemy_spawner.setup(player, floor, hud.boss_health, camera)

func start_room (wave_info_ : WaveInfo) -> void:
	# super(wave_info_)
	# enemy_spawner.set_wave_spawning(wave_info_)
	# enemy_spawner.spawn_boss("Angler", boss_spawn.global_transform.origin)

	enemy_spawner.spawn_enemy("LungingEnemy", Vector3(0,0,0))
	# var enemy_pool : Array[String] = ["AuraEnemy", "DashingEnemy", "ShootingEnemy","JumpingEnemy", "Barnacle"]
	var enemy_pool : Array[String] = ["LobbingEnemy", "ShootingEnemy"]
	var wave_info : CombatWaveInfo = CombatWaveInfo.new()
	wave_info.wave_number = 10
	wave_info.enemy_budget = 20
	wave_info.enemy_pool = enemy_pool
	enemy_spawner.set_wave_spawning(wave_info, self)

	# for i in range(10):
		# enemy_spawner.spawn_enemy("LungingEnemy", Vector3(i*0.5,0,0))


func map_cleared() -> bool:
	# for shrine : Shrine in shrines:
	# 	if shrine and shrine.activated:
	# 		return true
	return false

func get_spawn_pools() -> Dictionary[String, ShuffledPool] :
	var spawn_pools : Dictionary[String,ShuffledPool] = {
		"melee": ShuffledPool.create_shuffled_pool(melee_spawns.get_children()),
		"ranged": ShuffledPool.create_shuffled_pool(ranged_spawns.get_children()),
		"any": ShuffledPool.create_shuffled_pool(melee_spawns.get_children() + ranged_spawns.get_children()),
	}
	return spawn_pools
