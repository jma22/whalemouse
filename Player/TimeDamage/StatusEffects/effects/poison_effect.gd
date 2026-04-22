class_name PoisonEffect extends EnemyStatusEffect

const MAX_STACKS : int = 5
const EXPIRY_DAMAGE : int = 1
const COLOR_MIN : Color = Color(0.75, 1, 0.75)
const COLOR_MAX : Color = Color(0.25, 0.9, 0.25)
const TICK_DURATION : float = 3.0

static func make() -> PoisonEffect:
	var effect : PoisonEffect = PoisonEffect.new()
	effect.name = StatusEffectNames.POISON
	effect.time_remaining = TICK_DURATION
	effect.duration = TICK_DURATION
	effect.is_conditional = false
	effect.max_stacks = MAX_STACKS
	effect.stacks = 1
	return effect


func stack_with(existing: StatusEffectBase) -> void:
	existing.stacks = min(existing.stacks + 1, MAX_STACKS)
	existing.time_remaining = min(time_remaining, existing.time_remaining)

func on_expired(entity: Node3D) -> bool:
	if entity and "health_component" in entity:
		entity.health_component.take_damage(EXPIRY_DAMAGE)
		if "sprite_manager" in entity and entity.sprite_manager:
			entity.sprite_manager.damage_flash()
		if "hurt_box" in entity and entity.hurt_box and entity.hurt_box.hit_sound:
			entity.hurt_box.hit_sound.pitch_scale = 0.75 + randf() * 0.5
			entity.hurt_box.hit_sound.play()
	stacks -= 1
	if stacks > 0:
		time_remaining = duration
		return false
	return true

func get_color_overlay() -> Color:
	var t : float = float(stacks - 1) / float(max(max_stacks - 1, 1))
	return COLOR_MIN.lerp(COLOR_MAX, clamp(t, 0.0, 1.0))
