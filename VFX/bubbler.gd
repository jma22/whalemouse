extends GPUParticles3D


@export var audio_1 : AudioStreamPlayer
@export var audio_2 : AudioStreamPlayer
@export var audio_3 : AudioStreamPlayer

func start() -> void:
	emitting = true
	play_sound()
	await finished
	queue_free()


func play_sound() -> void:
	var rand : int = randi() % 3
	match rand:
		0:
			if audio_1 and audio_1.stream:
				audio_1.pitch_scale = 0.8 + randf() * 0.4
				audio_1.play()
		1:
			if audio_2 and audio_2.stream:
				audio_2.pitch_scale = 0.8 + randf() * 0.4
				audio_2.play()
		2:
			if audio_3 and audio_3.stream:
				audio_3.pitch_scale = 0.8 + randf() * 0.4
				audio_3.play()
