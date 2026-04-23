extends CollectibleBase
class_name EbbPickup

func on_pickup() -> void:
	TutorialManager.show_tutorial(TutorialManager.TutorialEnum.EBB_ORB)
	
	if target and target.has_method("gain_status_effect"):
		target.gain_status_effect(SlowEffect.make(1.5), self)
		if StatCalculator.get_flow_stacks_per_pickup() > 0:
			target.gain_status_effect(FlowEffect.make(StatCalculator.get_flow_stacks_per_pickup()), target)