extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volume_db = linear_to_db(Config.get_setting("volume", 0.5))
	Config.connect("settings_changed", Callable(self, "on_volume_changed"))

func on_volume_changed() -> void:
	# print(linear_to_db(Config.get_setting("volume", 0.5))-10)
	volume_db = linear_to_db(Config.get_setting("volume", 0.5))