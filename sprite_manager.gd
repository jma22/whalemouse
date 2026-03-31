extends Sprite3D

class_name SpriteManager

@export var frames_per_second = 4
var current_idx : int = 0
var time_accumulator : float = 0.0
var looping : bool = true
var current_animation : AnimationClip = null
var is_done : bool = false
func reset() -> void:
	current_idx = 0
	time_accumulator = 0.0
	current_animation = null
	looping = true
	modulate = Color(1, 1, 1, 1)

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
				is_done = true
		
		if current_animation != null:
			frame = current_animation.frame_numbers[current_idx]
		time_accumulator = 0.0


func play(animation: AnimationClip, loop: bool = true) -> void:
	if animation == null or animation.is_empty():
		return
	is_done = false
	current_animation = animation
	current_idx = 0
	time_accumulator = 0.0
	looping = loop
	frame = current_animation.frame_numbers[current_idx]
	print("Playing animation: ", animation.name)

func check_is_done() -> bool:
	return is_done
	
func set_flip(is_left: bool) -> void:
	self.flip_h = is_left

func damage_flash() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 0, 0, 1), 0.1)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.1)
	tween.play()

func die() -> Tween:
	# Play death animation, then queue_free
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.5)
	tween.play()
	return tween	
