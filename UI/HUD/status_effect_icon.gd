extends TextureProgressBar

class_name StatusEffectIcon
func setup(effect : StatusEffect) -> void:
	if effect.is_conditional:
		value = 1.0
		max_value = 1.0
	else:
		value = effect.time_remaining 
		max_value = effect.duration
	texture_progress = load(effect.get_icon_path())


func turn_off() -> void:
	value = 0