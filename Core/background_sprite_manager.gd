extends SpriteManager

class_name BackgroundSpriteManager


func _ready() -> void:
	super()
	await get_tree().process_frame
	if material_override is ShaderMaterial:
		material_override = material_override.duplicate()  
		if material_override.shader and _shader_has_uniform(material_override.shader, "albedo"):
			material_override.set_shader_parameter("albedo", texture)

