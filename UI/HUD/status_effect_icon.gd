extends TextureProgressBar

class_name StatusEffectIcon
func setup(effect : StatusEffect) -> void:
	value = effect.time_remaining 
	max_value = effect.duration
	texture_progress = load(effect.get_icon_path())


func turn_off() -> void:
	value = 0