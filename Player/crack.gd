extends Sprite3D

var offset_shift = Vector2(0, 0.2)
func play() -> void:
	rotation.x = -PI/2
	position += Vector3(offset_shift.x, 0, offset_shift.y)
	visible = true
	var tween = get_tree().create_tween()
	tween.tween_interval(0.5)
	tween.tween_property(self, "modulate:a", 0, 0.5).as_relative().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.tween_callback(Callable(self, "queue_free"))