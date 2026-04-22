extends TextureProgressBar

class_name StatusEffectIcon
func setup(effect : PlayerStatusEffect) -> void:
	if effect.is_conditional:
		value = 10.0
		max_value = 10.0
	else:
		value = effect.time_remaining *100.0
		max_value = effect.duration *100.0
	texture_progress = load(effect.get_icon_path())


func turn_off() -> void:
	value = 0