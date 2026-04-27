extends Node

const FLAGS_PATH := "res://Config/feature_flags.cfg"
const USER_FLAGS_PATH := "user://feature_flags.cfg"
# cd Appdata/Roaming/Godot/app_userdata/

enum Difficulty {
	EASY,
	NORMAL,
	HARD,
}
var _cfg := ConfigFile.new()
var _user_cfg := ConfigFile.new()

signal settings_changed

func _ready() -> void:
	var err := _cfg.load(FLAGS_PATH)
	if err != OK:
		push_warning("FeatureFlags: could not load %s (err %d)" % [FLAGS_PATH, err])
	# layer user overrides on top (may not exist yet, that's fine)
	_user_cfg.load(USER_FLAGS_PATH)
	reset_settings_to_default()
	print(ProjectSettings.globalize_path("user://feature_flags.cfg"))

func is_enabled(flag: String, default := false) -> bool:
	# user override wins, then bundled default
	if _user_cfg.has_section_key("flags", flag):
		return _user_cfg.get_value("flags", flag)
	return _cfg.get_value("flags", flag, default)


func get_float(key: String, default := 0.0) -> float:
	return _cfg.get_value("tuning", key, default)

func get_int(key: String, default := 0) -> int:
	return _cfg.get_value("tuning", key, default)

func get_override(key: String, default: Variant = null) -> Variant:
	if not OS.has_feature("editor"):
		return default  # overrides never apply in release builds
	return _cfg.get_value("overrides", key, default)


func set_setting(key: String, value: Variant, save := false) -> void:
	_user_cfg.set_value("settings", key, value)
	if save:
		_user_cfg.save(USER_FLAGS_PATH)
	emit_signal("settings_changed")

func get_setting(key: String, default: Variant = null) -> Variant:
	return _user_cfg.get_value("settings", key, default)

func reset_settings_to_default() -> void:
	for key in _cfg.get_section_keys("default_settings"):
		_user_cfg.set_value("settings", key, _cfg.get_value("default_settings", key))
	_user_cfg.save(USER_FLAGS_PATH)
	emit_signal("settings_changed")

func get_difficulty() -> Difficulty:
	var diff_str : String = get_setting("difficulty", "normal").to_lower()
	match diff_str:
		"easy":
			return Difficulty.EASY
		"hard":
			return Difficulty.HARD
		_:
			return Difficulty.NORMAL
