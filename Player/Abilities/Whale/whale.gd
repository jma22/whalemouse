extends Node3D

class_name Whale

@export var whale_animation_player : AnimationPlayer
@export var audio_player : AudioStreamPlayer



func play() -> void:
	audio_player.pitch_scale = 1.0
	audio_player.play()
	whale_animation_player.play("whale_animation")

# func whale_up() -> void:
# 	var tween = get_tree().create_tween()
# 	var original_y = whale_sprite.translation.y
# 	tween.tween_property(whale_sprite, "translation:y", original_y+ 1.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
# 	tween.tween_property(whale_sprite, "translation:y", original_y, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
# 	tween.play()
