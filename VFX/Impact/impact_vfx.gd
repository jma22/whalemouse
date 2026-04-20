extends GPUParticles3D

func setup(scale_ : float, is_crit: bool = false) -> void:
	process_material.scale_curve.curve.set_point_value(1, scale_)
	if is_crit:
		process_material.color = Color(1, 0, 0)
	else:
		process_material.color = Color(1, 1, 1)


func play() -> void:
	visible = true
	emitting = true
	await finished
	queue_free()