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
	return "res://UI/HUD/BlessingIcons/%s.png" % internal_name
	
func apply() -> void:
	for effect in effects:
		effect.call()

func is_blessing() -> bool:
	var blessing_types : Array[String] = ["blessing", "whale_blessing"]
	return blessing_type in blessing_types
