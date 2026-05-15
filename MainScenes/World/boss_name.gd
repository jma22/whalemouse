extends RichTextLabel

var tween : Tween
func fade_in() -> void:
	visible = true
	modulate.a = 0.0
	if tween:
		tween.kill()
	tween =	 create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "modulate:a", 1.0, 0.5)

func fade_out() -> void:
	if tween:
		tween.kill()
	tween =	 create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(self.hide)
