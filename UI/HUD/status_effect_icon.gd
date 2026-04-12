extends TextureProgressBar

class_name StatusEffectIcon
func setup(effect : StatusEffect) -> void:
	value = effect.time_remaining 
	max_value = effect.duration


func turn_off() -> void:
	value = 0