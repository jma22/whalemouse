class_name MarkEffect extends EnemyStatusEffect

const MAX_STACKS : int = 5
const DAMAGE_BONUS : int = 2
const COLOR_MIN : Color = Color(1, 0.75, 0.75)
const COLOR_MAX : Color = Color(1, 0.25, 0.25)

static func make() -> MarkEffect:
	var effect : MarkEffect = MarkEffect.new()
	effect.name = StatusEffectNames.MARK
	effect.time_remaining = -1.0
	effect.duration = -1.0
	effect.is_conditional = false
	effect.persists_forever = true
	effect.max_stacks = MAX_STACKS
	effect.stacks = 1
	return effect


func stack_with(existing: StatusEffectBase) -> void:
	existing.stacks = min(existing.stacks + 1, MAX_STACKS)

func modify_incoming_damage(info: DamageInfo) -> void:
	var bonus : int = DAMAGE_BONUS * stacks
	if bonus > 0:
		info.amount += bonus
		info.was_marked = true

func on_hit_consumed(_entity: Node3D, _info: DamageInfo) -> bool:
	return true

func on_owner_killed(_entity: Node3D, _killer: Object) -> void:
	# TODO: spawn on-kill payload at _entity.global_transform.origin
	pass

func get_color_overlay() -> Color:
	var t : float = float(stacks - 1) / float(max(max_stacks - 1, 1))
	return COLOR_MIN.lerp(COLOR_MAX, clamp(t, 0.0, 1.0))
