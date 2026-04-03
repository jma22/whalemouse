extends Node3D

class_name WorldManager
@export var map_manager: MapManager
@export var shrine_map_manager: ShrineMapManager

@export var player : Node3D
@export var player_spawn_point: Node3D

@export var hud : HUD
@export var time_damage : TimeDamageManager
@export var camera : Camera3D

@export var wave_text : WaveText
@export var wave_manager : WaveManager

@export var transition : CanvasLayer
@export var whale_spawner : WhaleSpawner


# func _ready() -> void:
# 	reset()
# 	setup()

func setup() -> void:
	map_manager.setup(player, camera)
	hud.setup(player)
	time_damage.setup(player)
	player.setup(hud)
	GlobalStats.setup(player, hud)
	transition.setup()
	whale_spawner.setup(map_manager)
	call_deferred("map_entered", true)

func reset() -> void:
	player.global_transform.origin = Vector3.ZERO
	player.reset()
	time_damage.reset()
	wave_manager.reset()

func map_entered(first_time: bool) -> void:
	if not first_time:
		transition.transition_out()
		await transition.tween.finished
	var wave_info : WaveInfo = wave_manager.get_current_wave_info()
	wave_text.display_wave_info(wave_info)
	if wave_info.room_type == "combat":
		player.global_transform.origin = Vector3.ZERO
		map_manager.start_room(wave_info)
	else:
		player.global_transform.origin = Vector3(20, 0, 0)
		shrine_map_manager.start_room(wave_info)

	transition.transition_in()
	# map_manager.spawn_enemies()
	# wave_manager.start_wave()

func next_wave() -> void:
	wave_manager.current_wave += 1
	map_entered(false)
