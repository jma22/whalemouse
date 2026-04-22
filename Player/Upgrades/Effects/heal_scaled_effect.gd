extends UpgradeEffect
class_name HealScaledEffect

func apply() -> void:
	GlobalStats.player.heal(StatCalculator.get_heal_amount())
