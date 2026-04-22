extends UpgradeEffect
class_name HealingLightEffect

func apply() -> void:
	GlobalStats.player.heal(StatCalculator.get_healing_light_heal())
