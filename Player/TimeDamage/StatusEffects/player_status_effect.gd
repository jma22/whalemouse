class_name PlayerStatusEffect extends StatusEffectBase

# Abstract-ish base for player-side effects. Concrete effects live in effects/
# and provide their own static create() factories.

func _init() -> void:
	is_enemy_effect = false
