extends UpgradeEffect
class_name DamageScaledEffect

func apply() -> void:
	GlobalStats.player.damage(StatCalculator.get_damage_amount())
