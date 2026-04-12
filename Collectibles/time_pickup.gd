extends CollectibleBase
class_name TimePickup

func on_pickup() -> void:
	if target and target.has_method("on_gain_time"):
		target.on_gain_time(1)