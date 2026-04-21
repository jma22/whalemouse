extends Node3D

class_name WorldManager
@export var map_manager: MapManagerBase
@export var shrine_map_manager: MapManagerBase
@export var boss_map_manager: MapManagerBase

@export var player : Node3D
# @export var player_spawn_point: Node3D

@export var hud : HUD
@export var time_damage : TimeDamageManager
@export var camera : Camera3D

@export var wave_text : WaveText
@export var wave_manager : WaveManager

@export var transition : CanvasLayer
@export var whale_spawner : WhaleSpawner


@export var loading_screen : CanvasLayer


# func _ready() -> void:
# 	reset()
# 	setup()

func setup() -> void:
	shrine_map_manager.setup(player, camera, hud)
	map_manager.setup(player, camera, hud)
	boss_map_manager.setup(player, camera, hud)
	hud.setup(player)
	time_damage.setup(player)
	player.setup(hud, camera)
	GlobalStats.setup(player, hud)
	transition.setup()
	whale_spawner.setup(player, camera)
	call_deferred("map_entered", true)
	## call  fade_out_loading() when above call is done 
	## wait tille camera velocity is 0 then call fadeoutlaoding
	await get_tree().process_frame
	## compare camera position each frame
	var previous_position : Vector3 = camera.global_transform.origin
	while true:
		await get_tree().process_frame
		var current_position : Vector3 = camera.global_transform.origin
		if current_position.distance_to(previous_position) < 0.01:
			break
		previous_position = current_position
	fade_out_loading()
	

func fade_out_loading() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(loading_screen.get_child(0), "modulate:a", 0.0, 1.0)
	tween.tween_callback(Callable(loading_screen, "hide"))
	tween.play()


func reset() -> void:
	# player.global_transform.origin = Vector3.ZERO
	player.reset()
	time_damage.reset()
	wave_manager.reset()
	hud.reset()

func map_entered(first_time: bool) -> void:
	if not first_time:
		transition.transition_out()
		await transition.tween.finished
	var wave_info : WaveInfo = wave_manager.enter_wave()
	wave_text.display_wave_info(wave_info)
	if wave_info.room_type == "combat":
		# player.global_transform.origin = Vector3.ZERO
		map_manager.start_room(wave_info)
		whale_spawner.enter_map(map_manager)
		player.enter_map(map_manager)
	elif wave_info.room_type == "shrine":
		# player.global_transform.origin = Vector3(20, 0, 0)
		shrine_map_manager.start_room(wave_info)
		player.enter_map(shrine_map_manager)
		# whale_spawner.enter_map(shrine_map_manager)
	elif wave_info.room_type == "boss":
		# player.global_transform.origin = Vector3(20, 0, 0)
		boss_map_manager.start_room(wave_info)
		whale_spawner.enter_map(boss_map_manager)
		player.enter_map(boss_map_manager)


	transition.transition_in()
	await transition.tween.finished
	# await wave_text.tween.finished
	if wave_manager.current_wave_state == WaveManager.WaveState.INTRO_BLESSING:
		TutorialManager.show_tutorial(TutorialManager.TutorialEnum.INTRO)
	# if wave_manager.current_wave == 11:
		# TutorialManager.show_tutorial(TutorialManager.TutorialEnum.GOODLUCK)
	if wave_manager.current_wave_state == WaveManager.WaveState.INTRO_COMBAT:
		TutorialManager.show_tutorial(TutorialManager.TutorialEnum.FIRSTARRIVE)
	if wave_manager.current_wave_state == WaveManager.WaveState.HARD_CURSE:
		TutorialManager.show_tutorial(TutorialManager.TutorialEnum.FIRST_CURSE)
	if wave_manager.current_wave_state == WaveManager.WaveState.BOSS_CHOICE:
		TutorialManager.show_tutorial(TutorialManager.TutorialEnum.BOSS_OPTION)
	if wave_manager.current_wave_state == WaveManager.WaveState.FUNNY:
		TutorialManager.show_tutorial(TutorialManager.TutorialEnum.FUNNY)
	

func next_wave() -> void:
	wave_manager.exit_wave()
	map_entered(false)
