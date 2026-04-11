extends Node

const FLAGS_PATH := "res://Config/feature_flags.cfg"

var _cfg := ConfigFile.new()

func _ready() -> void:
    var err := _cfg.load(FLAGS_PATH)
    if err != OK:
        push_warning("FeatureFlags: could not load %s (err %d)" % [FLAGS_PATH, err])

func is_enabled(flag: String, default := false) -> bool:
    return _cfg.get_value("flags", flag, default)

func get_float(key: String, default := 0.0) -> float:
    return _cfg.get_value("tuning", key, default)

func get_int(key: String, default := 0) -> int:
    return _cfg.get_value("tuning", key, default)

# lets you toggle at runtime and optionally save back to disk
func set_flag(flag: String, value: bool, save := false) -> void:
    _cfg.set_value("flags", flag, value)
    if save:
        _cfg.save(FLAGS_PATH)

func get_override(key: String, default: Variant = null) -> Variant:
    if not OS.has_feature("editor"):
        return default  # overrides never apply in release builds
    return _cfg.get_value("overrides", key, default)