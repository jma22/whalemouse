extends GPUParticles3D

func setup(scale_ : float) -> void:
	process_material.scale_curve.curve.set_point_value(1, scale_)


func play() -> void:
	visible = true
	emitting = true
	await finished
	queue_free()