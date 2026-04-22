extends UpgradeEffect
class_name DamageFlatEffect

var amount: int

func _init(_amount: int = 0) -> void:
	amount = _amount

func apply() -> void:
	GlobalStats.player.damage(amount)

func describe() -> String:
	return "[color=#FF0000]Lose " + str(amount) + "[/color]"
