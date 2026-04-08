extends RichTextLabel

var fade_duration : float = 1.0

func _ready() -> void:
# 	label.text = "asdasd"
	play_animation()

func set_up(_text : String) -> void:
	text = _text

func play_animation() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, fade_duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(self,  "position", Vector2(0, 50), fade_duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE).as_relative()
	tween.tween_callback(Callable(self, "queue_free"))
