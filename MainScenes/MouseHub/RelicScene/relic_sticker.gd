extends Control
class_name RelicSticker

@export var texture : TextureRect
var upgrade_string : String = ""
var unlocked : bool = false


func setup(upgrade_internal_name : String) -> void:
	var upgrade_data : UpgradeData = UpgradeRegistry.get_by_name(upgrade_internal_name)
	upgrade_string = upgrade_internal_name
	texture.texture = load(upgrade_data.get_icon_path())

	if GameData.is_unlocked(upgrade_internal_name):
		unlocked = true
		texture.modulate = Color(1, 1, 1, 1) # make it look unlocked
	else:
		unlocked = false
		texture.modulate = Color(1, 1, 1, 0.2) # make it look locked

