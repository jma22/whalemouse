extends CollectibleBase
class_name EbbPickup

const SLOW_DURATION : float = 1.5

func on_pickup() -> void:
	TutorialManager.show_tutorial(TutorialManager.TutorialEnum.EBB_ORB)
	
	if target and target.has_method("gain_status_effect"):
		target.gain_status_effect(SlowEffect.make(SLOW_DURATION), null)
		if StatCalculator.get_flow_stacks_per_pickup() > 0:
			target.gain_status_effect(FlowEffect.make(StatCalculator.get_flow_stacks_per_pickup()), null)
			DebugLog.dbg_from(self,"flow_stacks_per_pickup → gained Flow x%s" % StatCalculator.get_flow_stacks_per_pickup())