extends GPUParticles3D


func play() -> void:
	visible = true
	emitting = true
	await finished
	queue_free()