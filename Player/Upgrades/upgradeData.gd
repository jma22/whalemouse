extends Resource
class_name UpgradeData

var name: String
var type: String
var description_func: Callable

func _init(_name: String, _type: String, _description_func: Callable) -> void:
	name = _name
	type = _type
	description_func = _description_func

func get_description(level: int) -> String:
	return description_func.call(level)
