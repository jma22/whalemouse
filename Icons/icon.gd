extends Control
class_name Icon
@export var icon_texture: TextureRect
@export var text : RichTextLabel


func setup(blessing_name : String, num_value : int) -> void:
	print("Setting up icon for blessing: %s with value: %d" % [blessing_name, num_value])
	text.text = str(num_value)
	icon_texture.texture = load("res://Icons/%s.png" % blessing_name)
