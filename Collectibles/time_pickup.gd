extends CollectibleBase
class_name TimePickup

func on_pickup() -> void:
	if target and target.has_method("on_gain_time"):
		target.on_gain_time(1)
	if StatCalculator.get_flow_stacks_per_pickup() > 0:
		target.gain_status_effect(FlowEffect.make(StatCalculator.get_flow_stacks_per_pickup()), null)
		DebugLog.dbg("EbbPickup", "flow_stacks_per_pickup → gained Flow x%s" % StatCalculator.get_flow_stacks_per_pickup())