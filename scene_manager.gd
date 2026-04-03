extends Node

enum SceneEnum {
	MAIN_MENU,
	GAME,
	PAUSE_MENU,
	GAME_OVER
}

var all_scenes : Dictionary[SceneEnum, Node3D] = {}

# var _stack: Array[PackedScene] = []
var _current: Node3D = null
var _container: Node3D

func setup(container: Node3D) -> void:
	_container = container
	register(SceneEnum.MAIN_MENU, "res://MainMenu/main_menu_scene.tscn")
	register(SceneEnum.GAME, "res://world.tscn")
	# register(SceneEnum.PAUSE_MENU, "res://PauseMenu/pause_menu_scene.tscn")
	register(SceneEnum.GAME_OVER, "res://GameOver/game_over_scene.tscn")
	switch_to(SceneEnum.MAIN_MENU)

func register(scene_enum: SceneEnum, path : String) -> void:
	var scene : Node3D = load(path).instantiate()
	all_scenes[scene_enum] = scene


func switch_to(scene_enum: SceneEnum) -> void:
	if scene_enum not in all_scenes:
		return 
	deactivate()
	_current = all_scenes[scene_enum]
	activate()


func deactivate() -> void:
	if _current:
		_current.visible = false
		_current.process_mode = PROCESS_MODE_DISABLED
		_container.remove_child(_current)

func activate() -> void:
	if _current:
		_current.visible = true
		_current.process_mode = PROCESS_MODE_INHERIT
		_container.add_child(_current)
		if _current.has_method("setup"):
			_current.setup()

func reset_game() -> void:
	var game_scene = all_scenes[SceneEnum.GAME]
	var world_manager = game_scene as WorldManager
	if world_manager:
		world_manager.reset()
		world_manager.setup()
	GlobalStats.reset_current_run_stats()

func next_wave() -> void:
	var game_scene = all_scenes[SceneEnum.GAME]
	var world_manager = game_scene as WorldManager
	if world_manager:
		world_manager.next_wave()

func pause_game() -> void:
	var game_scene = all_scenes[SceneEnum.GAME]
	var world_manager = game_scene as WorldManager
	if world_manager:
		world_manager.pause_game()

func resume_game() -> void:
	var game_scene = all_scenes[SceneEnum.GAME]
	var world_manager = game_scene as WorldManager
	if world_manager:
		world_manager.resume_game()