extends MapManagerBase
class_name WaveMapManager

@export var enemy_spawner : EnemySpawner

@export var ranged_spawns : Node3D
@export var melee_spawns : Node3D


func setup(player : CharacterBody3D, camera : Camera3D, hud : HUD) -> void:
	super(player, camera, hud)
	enemy_spawner.setup(player, floor, hud.boss_health)


func start_room (wave_info_ : WaveInfo) -> void:
	super(wave_info_)
	enemy_spawner.set_wave_spawning(wave_info_, self)
	if GlobalStats.get_ebb_begin_of_room() > 0:
		player.gain_status_effect(StatusEffect.create("slow", GlobalStats.get_ebb_begin_of_room()), self)


func map_cleared() -> bool:
	if wave_info and not enemy_spawner.spawner_done():
		return false
	return enemy_spawner.all_dead()


func leave_room() -> void:
	super()
	GlobalStats.decrement_wave_augments()


func get_spawn_pools() -> Dictionary[String, ShuffledPool] :
	var spawn_pools : Dictionary[String,ShuffledPool] = {
		"melee": ShuffledPool.create_shuffled_pool(melee_spawns.get_children()),
		"ranged": ShuffledPool.create_shuffled_pool(ranged_spawns.get_children()),
		"any": ShuffledPool.create_shuffled_pool(melee_spawns.get_children() + ranged_spawns.get_children()),
	}
	return spawn_pools