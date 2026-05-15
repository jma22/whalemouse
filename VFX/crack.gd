extends SpriteManager

var offset_shift : Vector2  = Vector2(0, 0.05)

var animation_clip : AnimationClip = AnimationClip.new()
func play_crack() -> void:
	animation_clip.frame_numbers = [2,1,0]
	rotation.x = -PI/2
	position += Vector3(offset_shift.x, 0, offset_shift.y)
	visible = true

	var tween : Tween = get_tree().create_tween()
	tween.tween_interval(0.3)
	tween.tween_callback(play.bind(animation_clip,false))
	tween.tween_property(self, "modulate:a", 0, 0.2).as_relative().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	
	tween.tween_callback(Callable(self, "queue_free"))
