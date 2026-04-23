extends Resource
class_name Choice

var display_name: String
var description_func: Callable
var _sprite_path : Resource

func _init(_display_name: String = "", _description_func: Callable = Callable()) -> void:
	display_name = _display_name
	description_func = _description_func

func get_description() -> String:
	if description_func.is_valid():
		return description_func.call()
	return ""

func apply() -> void:
	pass

func is_blessing() -> bool:
	return true

func get_sprite_path() ->  String:
	return _sprite_path.get_icon_path_for(&"")

func get_icon_path() -> String:
	return Choice.get_icon_path_for(&"")

static func get_icon_path_for(internal_name: StringName) -> String:
	var correct_path: String = "res://UI/HUD/BlessingIcons/%s.png" % internal_name
	var placeholder_path: String = "res://UI/HUD/BlessingIcons/Placeholders/%s.png" % internal_name
	if ResourceLoader.exists(correct_path):
		return correct_path
	return placeholder_path
