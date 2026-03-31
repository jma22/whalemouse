extends Node3D

@export var sprite_manager : SpriteManager
var animation_clip : AnimationClip

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_clip = AnimationClip.new()
	animation_clip.frame_numbers = [0,1,2,3]
	play()


func play() -> void:
	sprite_manager.play(animation_clip, false)
	var tween = get_tree().create_tween()
	###  make a sudden curve that starts big and then quickly goes back to normal
	
	tween.tween_property(self, "scale", Vector3(1.5, 1.5, 1.5), 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite_manager, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.play()
