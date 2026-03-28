extends Sprite3D

class_name SpriteManager

@export var frames_per_second = 4
var current_idx : int = 0
var time_accumulator : float = 0.0
var looping : bool = true
var current_animation : AnimationClip = null


func _process(delta: float) -> void:
	if current_animation == null:
		return
	
	time_accumulator += delta
	var frame_time = 1.0 / frames_per_second
	if time_accumulator >= frame_time:
		current_idx += 1
		if current_idx >= current_animation.frame_numbers.size():
			if looping:
				current_idx = 0
			else:
				current_idx = current_animation.frame_numbers.size() - 1
				current_animation = null
		frame = current_animation.frame_numbers[current_idx]
		time_accumulator = 0.0


func play(animation: AnimationClip, loop: bool = true) -> void:
	if animation.is_empty():
		return
	current_animation = animation
	current_idx = 0
	time_accumulator = 0.0
	looping = loop
	frame = current_animation.frame_numbers[current_idx]
	
func set_flip(is_left: bool) -> void:
	self.flip_h = is_left
