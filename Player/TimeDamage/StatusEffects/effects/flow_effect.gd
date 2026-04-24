class_name FlowEffect extends PlayerStatusEffect

const DURATION: float = 2.0
const SPEED_PER_STACK: float = 0.07

static func make(p_stacks: int) -> FlowEffect:
	var effect := FlowEffect.new()
	effect.name = StatusEffectNames.FLOW
	effect.time_remaining = DURATION
	effect.duration = DURATION
	effect.stacks = p_stacks
	effect.max_stacks = 10
	return effect

func get_speed_multiplier() -> float:
	return (1.0 + (stacks * SPEED_PER_STACK * (time_remaining / DURATION) ** 0.5))

func _stack_with(existing: StatusEffectBase) -> void:
	existing.time_remaining = DURATION
	existing.stacks = min(existing.stacks + stacks, max_stacks)

func get_color_overlay() -> Color:
	return Color(0.4, 0.9, 1.0, 0.3)
