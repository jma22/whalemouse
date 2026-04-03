extends GPUParticles3D


func start() -> void:
	emitting = true
	await finished
	queue_free()