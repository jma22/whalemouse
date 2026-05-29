extends Node3D
class_name WorldManager
static var instance : WorldManager

@export_group("Player")
@export var player : Node3D
@export var time_damage : TimeDamageManager
@export var wave_manager : WaveManager
@export var camera : Camera3D
@export var ability_caster : AbilityCaster
# @export var player_spawn_point: Node3D

@export_group("Maps")
@export var map_manager: MapManagerBase
@export var shrine_map_manager: MapManagerBase
@export var boss_map_manager: MapManagerBase

@export_group("UI")
@export var hud : HUD
@export var wave_text : WaveText
@export var transition : CanvasLayer
@export var loading_screen : CanvasLayer
@export var death_screen : DeathScreen

func _enter_tree() -> void:
	instance = self


# func _ready() -> void:
# 	reset()
# 	setup()

func setup() -> void:
	var _t := func(label: String, start: int) -> void:
		print("[setup] %s: %.2f ms" % [label, (Time.get_ticks_usec() - start) / 1000.0])
	var _t0 := Time.get_ticks_usec()

	await get_tree().process_frame
	var _ts := Time.get_ticks_usec()
	_t.call("process_frame", _t0)
	shrine_map_manager.setup(player, camera, hud); _t.call("shrine_map_manager.setup", _ts); _ts = Time.get_ticks_usec()
	map_manager.setup(player, camera, hud); _t.call("map_manager.setup", _ts); _ts = Time.get_ticks_usec()
	boss_map_manager.setup(player, camera, hud); _t.call("boss_map_manager.setup", _ts); _ts = Time.get_ticks_usec()
	hud.setup(player); _t.call("hud.setup", _ts); _ts = Time.get_ticks_usec()
	time_damage.setup(player); _t.call("time_damage.setup", _ts); _ts = Time.get_ticks_usec()
	player.setup(hud, camera); _t.call("player.setup", _ts); _ts = Time.get_ticks_usec()
	GlobalStats.setup(player); _t.call("GlobalStats.setup", _ts); _ts = Time.get_ticks_usec()
	transition.setup(); _t.call("transition.setup", _ts); _ts = Time.get_ticks_usec()
	ability_caster.setup(player, camera); _t.call("ability_caster.setup", _ts); _ts = Time.get_ticks_usec()
	death_screen.setup(); _t.call("death_screen.setup", _ts); _ts = Time.get_ticks_usec()
	var wave_info := map_entered_setup(); _t.call("map_entered_setup", _ts); _ts = Time.get_ticks_usec()
	## call  fade_out_loading() when above call is done
	## wait tille camera velocity is 0 then call fadeoutlaoding
	# await get_tree().process_frame
	## compare camera position each frame
	var previous_position : Vector3 = camera.global_transform.origin
	var camera_settle_start := Time.get_ticks_msec()
	while true:
		await get_tree().process_frame
		var current_position : Vector3 = camera.global_transform.origin
		if current_position.distance_to(previous_position) < 0.01:
			break
		if Time.get_ticks_msec() - camera_settle_start > 3000:
			DebugLog.dbg_from(self, "camera settle timed out after 3s")
			break
		previous_position = current_position

	_ts = Time.get_ticks_usec()
	await fade_out_loading(); _t.call("fade_out_loading", _ts); _ts = Time.get_ticks_usec()
	await map_entered_animate(wave_info, true); _t.call("map_entered_animate", _ts); _ts = Time.get_ticks_usec()

	print("[setup] TOTAL: %.2f ms" % [(Time.get_ticks_usec() - _t0) / 1000.0])


	

func fade_out_loading() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(loading_screen.get_child(0), "modulate:a", 0.0, 0.4)
	tween.tween_callback(Callable(loading_screen, "hide"))
	await tween.finished
	


func reset() -> void:
	# player.global_transform.origin = Vector3.ZERO
	player.reset()
	time_damage.reset()
	wave_manager.reset()
	hud.reset()

func map_entered() -> void:
	var wave_info := map_entered_setup()
	await map_entered_animate(wave_info, false)

func map_entered_setup() -> WaveInfo:
	var wave_info := wave_manager.enter_wave()
	match wave_info.room_type:
		WaveInfo.WaveType.Combat:
			map_manager.start_room(wave_info)
			ability_caster.enter_map(map_manager)
			player.enter_map(map_manager)
		WaveInfo.WaveType.Shrine:
			shrine_map_manager.start_room(wave_info)
			player.enter_map(shrine_map_manager)
			ability_caster.enter_map(shrine_map_manager)
		WaveInfo.WaveType.Boss:
			boss_map_manager.start_room(wave_info)
			ability_caster.enter_map(boss_map_manager)
			player.enter_map(boss_map_manager)
	return wave_info

func map_entered_animate(wave_info: WaveInfo, first_time: bool) -> void:
	if not first_time:
		transition.transition_out()
		await transition.tween.finished
	wave_text.display_wave_info(wave_info)
	transition.transition_in()
	await transition.tween.finished
	if wave_manager.current_wave_state == WaveManager.WaveState.INTRO_BLESSING:
		TutorialManager.show_tutorial(TutorialManager.TutorialEnum.INTRO)
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
	map_entered()


func gameover_animation() -> void:
	player.sprite_manager.alpha_cut = SpriteBase3D.ALPHA_CUT_DISABLED
	player.sprite_manager.set_render_priority(127)
	await death_screen.play()
	SceneManager.switch_to(SceneManager.SceneEnum.GAME_OVER)
