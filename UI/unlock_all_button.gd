extends Button


func _ready() -> void:
	button_pressed = Config.get_setting("user_unlock_all", false)
	toggled.connect(_on_value_changed)
	

func _on_value_changed(value_: bool) -> void:
	Config.set_setting("user_unlock_all", value_,true)
