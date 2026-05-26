extends MeshInstance3D
class_name DeathScreen

func setup() -> void:
	material_override.set_shader_parameter("radius", 2.0)
	# $LosingText.modulate.a = 0.0

func play() -> void:
	var mat: ShaderMaterial = material_override
	var tween := create_tween()
	tween.tween_property(mat, "shader_parameter/radius", 0.0, 1.5) \
		 .from(1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	# tween.tween_property($LosingText, "modulate:a", 1.0, 0.5) \
	#      .set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_interval(1.0)
	await tween.finished
