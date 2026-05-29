extends Node3D

class_name Whale

@export var whale_animation_player : AnimationPlayer
@export var audio_player : AudioStreamPlayer
@export var hitbox : Hitbox

var whale_spawner : WhaleAbility

func play(whale_spawner_ : WhaleAbility) -> void:
	self.whale_spawner = whale_spawner_

	hitbox.set_damage(1)
	var whale_hitbox_behavior : WhaleHitboxBehavior = WhaleHitboxBehavior.make()
	hitbox.set_behavior(whale_hitbox_behavior)
	audio_player.pitch_scale = 1.0
	audio_player.play()
	whale_animation_player.play("whale_animation")
	


func camera_shake_callback() -> void:
	if GlobalStats.current_run_stats["whale_size"] >= 3:
		whale_spawner.camera_shake_callback()



# func whale_up() -> void:
# 	var tween = get_tree().create_tween()
# 	var original_y = whale_sprite.translation.y
# 	tween.tween_property(whale_sprite, "translation:y", original_y+ 1.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
# 	tween.tween_property(whale_sprite, "translation:y", original_y, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
# 	tween.play()
