extends CollectibleBase
class_name EbbPickup

func on_pickup() -> void:
	TutorialManager.show_tutorial(TutorialManager.TutorialEnum.EBB_ORB)
	
	if target and target.has_method("gain_status_effect"):
		target.gain_status_effect(PlayerStatusEffect.create("slow", 1.5), self)