extends CanvasLayer

@export var texture: TextureRect
var tween: Tween

func _ready() -> void:
	visible = false

func setup() -> void:
	var material : ShaderMaterial = texture.material
	material.set_shader_parameter("width", 0)
	material.set_shader_parameter("factor", 1.0)

func transition_out() -> void:
	visible = true
	var material : ShaderMaterial = texture.material
	material.set_shader_parameter("width", -0.00001)
	material.set_shader_parameter("factor", 1.0)
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.tween_property(material, "shader_parameter/factor", 0.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

func transition_in() -> void:
	# if tween and tween.is_valid():
	# 	await tween.finished
	var material : ShaderMaterial = texture.material
	material.set_shader_parameter("width", 0)
	material.set_shader_parameter("factor", 1.0)
	tween = create_tween()
	tween.tween_interval(0.5)
	tween.tween_property(material, "shader_parameter/factor", 0.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(on_transition_in_finished)

func on_transition_in_finished() ->void:
	visible = false
