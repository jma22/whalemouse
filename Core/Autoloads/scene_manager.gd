extends Node

enum SceneEnum {
	MAIN_MENU,
	GAME,
	PAUSE_MENU,
	GAME_OVER,
	UNLOCK
}

var all_scenes : Dictionary[SceneEnum, Node3D] = {}

# var _stack: Array[PackedScene] = []
var _current: Node3D = null
var _container: Node3D
var _current_enum: SceneEnum = SceneEnum.MAIN_MENU
var new_unlocks : Array[String] = []

func _dbg(str : String) -> void:
	DebugLog.dbg("SceneManager", str)

func setup(container: Node3D) -> void:
	_container = container
	register(SceneEnum.MAIN_MENU, "res://MainScenes/MainMenu/main_menu_scene.tscn")
	register(SceneEnum.GAME, "res://MainScenes/World/world.tscn")
	# register(SceneEnum.PAUSE_MENU, "res://PauseMenu/pause_menu_scene.tscn")
	register(SceneEnum.GAME_OVER, "res://MainScenes/GameOver/game_over_scene.tscn")
	register(SceneEnum.UNLOCK, "res://MainScenes/UnlockScene/unlock_scene.tscn")
	switch_to(SceneEnum.MAIN_MENU)

func register(scene_enum: SceneEnum, path : String) -> void:
	var scene : Node3D = load(path).instantiate()
	all_scenes[scene_enum] = scene


func switch_to(scene_enum: SceneEnum, setup_args : Array = []) -> void:
	if scene_enum not in all_scenes:
		return
		
	set_paused(false)
		
	deactivate()
	_current_enum = scene_enum
	_current = all_scenes[scene_enum]
	print("Current scene enum: ", _current_enum)
	activate(setup_args)

func deactivate() -> void:
	if _current:
		_current.visible = false
		_current.process_mode = PROCESS_MODE_DISABLED
		_container.remove_child(_current)

func activate(setup_args: Array = []) -> void:
	if _current:
		_container.add_child(_current)

		if _current.has_method("setup"):
			_current.callv("setup", setup_args)
		_current.visible = true
		_current.process_mode = PROCESS_MODE_INHERIT
		

func clear_game() -> void:
	if not all_scenes:
		printerr("All scenes array is empty!"); get_tree().quit()
		return
	_dbg("clearing game")

	GlobalStats.reset_current_run_stats()
	UpgradePicker.reset()

	if all_scenes.has(SceneEnum.GAME):
		all_scenes[SceneEnum.GAME].queue_free()
		all_scenes.erase(SceneEnum.GAME)

	register(SceneEnum.GAME, "res://MainScenes/World/world.tscn")

func next_wave() -> void:
	var game_scene : Node3D = all_scenes[SceneEnum.GAME]
	var world_manager : WorldManager = game_scene as WorldManager
	if world_manager:
		world_manager.next_wave()

func set_paused(paused: bool) -> void:
	var tree : SceneTree = get_tree()
	if tree:
		tree.paused = paused

func add_unlocks(unlocks : Array[String]) -> void:
	_dbg("Unlocks: " + ",".join(unlocks))
	new_unlocks.append_array(unlocks)

func can_pause() -> bool:
	# Prevent pausing on main menu
	return _current_enum == SceneEnum.GAME or _current_enum == SceneEnum.PAUSE_MENU

func next_scene() -> void:
	## only used after game over scene at the moment
	_dbg("Next Scene: have unlocks "  + ",".join(new_unlocks))
	if new_unlocks:
		var upgrade_name : String = new_unlocks.pop_front()
		switch_to(SceneEnum.UNLOCK, [upgrade_name])
	else:
		switch_to(SceneEnum.MAIN_MENU)
