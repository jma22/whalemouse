extends UpgradeEffect
class_name IncreaseStatEffect

var stat: StringName
var amount: int = 1

func _init(_stat: StringName = &"", _amount: int = 1) -> void:
	stat = _stat
	amount = _amount

func apply() -> void:
	for i in amount:
		GlobalStats.add_to_stat(stat)

func affects_stat(stat_name: StringName) -> bool:
	return stat_name == stat
