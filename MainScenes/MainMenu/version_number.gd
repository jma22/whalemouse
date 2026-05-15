extends RichTextLabel

func _ready() -> void:
	text = "V%s" % ProjectSettings.get_setting("application/config/version") + "  " 