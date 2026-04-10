extends TextureProgressBar

class_name StatusEffectIcon
func setup(effect : StatusEffect) -> void:
	print("Setting up icon for effect: " + effect.name + " with time remaining: " + str(effect.time_remaining))
	value = effect.time_remaining 
	max_value = effect.duration


func turn_off() -> void:
	print("Turning off status effect icon")
	value = 0