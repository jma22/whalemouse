class_name EnemyStatusEffect extends StatusEffectBase

# Abstract-ish base for enemy-side effects. Concrete effects live in effects/
# and provide their own static create() factories.

func _init() -> void:
	is_enemy_effect = true
