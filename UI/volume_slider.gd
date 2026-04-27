extends HSlider


func _ready() -> void:
	value = Config.get_setting("volume", 0.25)
	value_changed.connect(_on_value_changed)
	

func _on_value_changed(value_: float) -> void:
	Config.set_setting("volume", value_,true)
