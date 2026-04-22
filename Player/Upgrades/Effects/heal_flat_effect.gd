extends UpgradeEffect
class_name HealFlatEffect

var amount: int

func _init(_amount: int = 0) -> void:
	amount = _amount

func apply() -> void:
	GlobalStats.player.heal(amount)

func describe() -> String:
	return "[color=#00FF00]Heal " + str(amount) + "[/color]"
