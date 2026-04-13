extends CollectibleBase
class_name EbbPickup

func on_pickup() -> void:
	if target and target.has_method("gain_status_effect"):
		target.gain_status_effect(StatusEffect.create("slow", 4.0))