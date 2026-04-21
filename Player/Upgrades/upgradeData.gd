extends Resource
class_name UpgradeData

var display_name: String
var internal_name: String
var blessing_type: String 
var description_func: Callable
var effects : Array[Callable] = []

func _init(_internal_name : String, _display_name: String, _blessing_type: String, _description_func: Callable, _effects: Array[Callable] = []) -> void:
	effects = _effects
	display_name = _display_name
	internal_name = _internal_name
	blessing_type = _blessing_type
	description_func = _description_func

func get_description() -> String:
	return description_func.call()

func get_icon_path() -> String:
	return UpgradeData.get_icon_path_static(internal_name)
	
func apply() -> void:
	Upgrades.chosen_upgrade(self)
	for effect in effects:
		effect.call()

func is_blessing() -> bool:
	var blessing_types : Array[String] = ["blessing", "whale_blessing", "one_time_blessing","boss_blessing"]
	return blessing_type in blessing_types

static func get_icon_path_static(internal_name_ : String) -> String:
	var correct_path : String = "res://UI/HUD/BlessingIcons/%s.png" % internal_name_
	var placeholder_path : String = "res://UI/HUD/BlessingIcons/Placeholders/%s.png" % internal_name_
	if ResourceLoader.exists(correct_path):
		return correct_path
	else:
		return placeholder_path

func has_belugas_blessing() -> bool:
	return internal_name == "time_tick_level"
