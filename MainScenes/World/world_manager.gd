extends Node3D

class_name WorldManager
@export var map_manager: MapManager
@export var shrine_map_manager: ShrineMapManager

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
	shrine_map_manager.setup(player, camera)
	map_manager.setup(player, camera)
	hud.setup(player)
	time_damage.setup(player)
	player.setup(hud)
	GlobalStats.setup(player, hud)
	transition.setup()
	whale_spawner.setup(map_manager)
	call_deferred("map_entered", true)
	## call  fade_out_loading() when above call is done 
	## wait tille camera velocity is 0 then call fadeoutlaoding
	await get_tree().process_frame
	## compare camera position each frame
	var previous_position = camera.global_transform.origin
	while true:
		await get_tree().process_frame
		var current_position = camera.global_transform.origin
		if current_position.distance_to(previous_position) < 0.01:
			break
		previous_position = current_position
	fade_out_loading()
	

func fade_out_loading() -> void:
	var tween = create_tween()
	tween.tween_property(loading_screen.get_child(0), "modulate:a", 0.0, 1.0)
	tween.tween_callback(Callable(loading_screen, "hide"))
	tween.play()


func reset() -> void:
	# player.global_transform.origin = Vector3.ZERO
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
		# player.global_transform.origin = Vector3.ZERO
		map_manager.start_room(wave_info)
	else:
		# player.global_transform.origin = Vector3(20, 0, 0)
		shrine_map_manager.start_room(wave_info)

	transition.transition_in()
	await transition.tween.finished
	# await wave_text.tween.finished
	if first_time:
		TutorialManager.show_tutorial(TutorialManager.TutorialEnum.INTRO)
	if wave_manager.current_wave == 11:
		TutorialManager.show_tutorial(TutorialManager.TutorialEnum.GOODLUCK)
	if wave_manager.current_wave == 1:
		TutorialManager.show_tutorial(TutorialManager.TutorialEnum.FIRSTARRIVE)
	if wave_manager.current_wave == 5:
		TutorialManager.show_tutorial(TutorialManager.TutorialEnum.FIRST_CURSE)
	if wave_manager.current_wave == 10:
		TutorialManager.show_tutorial(TutorialManager.TutorialEnum.CURSE_OF_THE_DEPTHS)
	if wave_manager.current_wave == 4:
		TutorialManager.show_tutorial(TutorialManager.TutorialEnum.SECOND_CHOICE)

	

func next_wave() -> void:
	wave_manager.current_wave += 1
	map_entered(false)

func pause_game() -> void:
	get_tree().paused = true

func resume_game() -> void:
	get_tree().paused = false
