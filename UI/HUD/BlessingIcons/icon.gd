extends Control
class_name Icon
@export var icon_texture: TextureRect
@export var text : RichTextLabel


func setup(blessing_name : String, num_value : int) -> void:
	print("Setting up icon for blessing: %s with value: %d" % [blessing_name, num_value])
	text.text = str(num_value)
	var upgrade : Choice = Upgrades.get_upgrade(blessing_name)
	if upgrade == null:
		return 
	icon_texture.texture = load(upgrade.get_icon_path())
	if StatCalculator.is_positive_stat(blessing_name):
		text.add_theme_color_override("font_color", Color(0.48235294, 0, 0, 1))
	else:
		text.add_theme_color_override("font_color", Color(0.14509805, 0.7607843, 0.19607843, 1))
