extends MapManagerBase
class_name WaveMapManager

@export var enemy_spawner : EnemySpawner


func setup(player : CharacterBody3D, camera : Camera3D, hud : HUD) -> void:
	super(player, camera, hud)
	enemy_spawner.setup(player, floor, hud.boss_health)


func start_room (wave_info_ : WaveInfo) -> void:
	super(wave_info_)
	enemy_spawner.set_wave_spawning(wave_info_)
	if GlobalStats.get_ebb_begin_of_room() > 0:
		player.gain_status_effect(StatusEffect.create("slow", GlobalStats.get_ebb_begin_of_room()), self)


func map_cleared() -> bool:
	if wave_info and not enemy_spawner.spawner_done():
		return false
	return enemy_spawner.all_dead()


func leave_room() -> void:
	super()
	GlobalStats.decrement_wave_augments()