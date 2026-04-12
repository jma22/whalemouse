extends Resource
class_name UpgradeData

var name: String
var isBlessing: bool 
var description_func: Callable

func _init(_name: String, _type: bool, _description_func: Callable) -> void:
	name = _name
	isBlessing = _type
	description_func = _description_func

func get_description(level: int) -> String:
	return description_func.call(level)
