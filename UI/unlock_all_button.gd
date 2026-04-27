extends Button
@export var field_name : String
@export var default_value : bool = false

func _ready() -> void:
	button_pressed = Config.get_setting(field_name, default_value)
	toggled.connect(_on_value_changed)
	

func _on_value_changed(value_: bool) -> void:
	Config.set_setting(field_name, value_, true)
