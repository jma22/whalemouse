extends MapManagerBase
class_name WaveMapManager

@export var enemy_spawner : EnemySpawner


func setup(player : CharacterBody3D, camera : Camera3D) -> void:
	super(player, camera)
	enemy_spawner.setup(player, floor)


func start_room (wave_info_ : WaveInfo) -> void:
	super(wave_info_)
	enemy_spawner.set_wave_spawning(wave_info_)
	player.clear_effects()


func map_cleared() -> bool:
	if wave_info and not enemy_spawner.spawner_done():
		return false

	return enemy_spawner.all_dead()
