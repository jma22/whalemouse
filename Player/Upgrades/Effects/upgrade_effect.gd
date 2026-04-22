extends Resource
class_name UpgradeEffect

func apply() -> void:
	pass

func describe() -> String:
	return ""

func affects_stat(_stat_name: StringName) -> bool:
	return false
