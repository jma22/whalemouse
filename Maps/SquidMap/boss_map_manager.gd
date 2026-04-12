extends MapManagerBase
class_name BossMapManager

@export var enemy_spawner : EnemySpawner


func setup(player : CharacterBody3D, camera : Camera3D, hud : HUD) -> void:
	super(player, camera, hud)
	enemy_spawner.setup(player, floor, hud.boss_health)


func start_room (wave_info_ : WaveInfo) -> void:
	super(wave_info_)
	# enemy_spawner.set_wave_spawning(wave_info_)
	enemy_spawner.spawn_boss(wave_info_.boss_name, Vector3.ZERO)
	
func map_cleared() -> bool:
	print("hi map clear checking")
	if wave_info and not enemy_spawner.spawner_done():
		return false
	return enemy_spawner.all_dead()
