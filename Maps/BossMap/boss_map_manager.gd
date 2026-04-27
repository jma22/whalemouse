extends MapManagerBase
class_name BossMapManager

@export var enemy_spawner : EnemySpawner
@export var boss_spawn : Node3D

var boss : EnemyBase = null
func setup(player : CharacterBody3D, camera : Camera3D, hud : HUD) -> void:
	super(player, camera, hud)
	enemy_spawner.setup(player, floor, hud.boss_health, camera)


func start_room (wave_info_ : WaveInfo) -> void:
	super(wave_info_)
	camera.set_boss_mode()
	camera.set_combat(true)

	# enemy_spawner.set_wave_spawning(wave_info_)
	boss = enemy_spawner.spawn_boss(wave_info_.boss_name, boss_spawn.global_transform.origin)
	
	player.gain_status_effect(FreezeEffect.make(StatCalculator.get_boss_freeze_time()), self)
	print("Boss freeze time:", StatCalculator.get_boss_freeze_time())
	
func map_cleared() -> bool:
	if not wave_info:
		return false
	return boss and boss.is_dead
