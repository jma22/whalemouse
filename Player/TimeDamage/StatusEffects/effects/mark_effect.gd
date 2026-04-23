class_name MarkEffect extends EnemyStatusEffect

const MAX_STACKS : int = 5
const DAMAGE_BONUS : int = 2
const COLOR_MIN : Color = Color(1, 0.75, 0.75)
const COLOR_MAX : Color = Color(1, 0.25, 0.25)

var _should_auto_consume: bool = false

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
	if StatCalculator.auto_consume_mark() and existing.stacks >= MAX_STACKS:
		_should_auto_consume = true
	else:
		existing.stacks = min(existing.stacks + 1, MAX_STACKS)

func modify_incoming_damage(info: DamageInfo) -> void:
	var bonus : int = DAMAGE_BONUS * stacks
	if bonus > 0:
		info.amount += bonus
		info.was_marked = true

func on_hit_consumed(_entity: Node3D, _info: DamageInfo) -> bool:
	if StatCalculator.mark_to_orb():
		_spawn_orbs(_entity, stacks)
	return true


func on_applied(_entity: Node3D) -> void:
	if _should_auto_consume:
		_do_auto_consume(_entity)
		return

	var needed : int = StatCalculator.marks_needed_to_make_bomb()
	if needed > 0 and _get_entity_mark_stacks(_entity) == needed:
		var explosion : PackedScene = preload("res://Enemies/Projectiles/Explosion.tscn")
		var explosion_instance : Node3D = explosion.instantiate()
		_entity.get_parent().add_child(explosion_instance)
		explosion_instance.global_transform.origin = _entity.global_transform.origin
		explosion_instance.global_transform.origin.y = 0.0
		explosion_instance.setup(source)


func _get_entity_mark_stacks(_entity: Node3D) -> int:
	if _entity and "status_effect_manager" in _entity:
		for effect : StatusEffectBase in _entity.status_effect_manager.timed_effects:
			if effect.name == StatusEffectNames.MARK:
				return effect.stacks
	return stacks


func _do_auto_consume(_entity: Node3D) -> void:
	if not _entity or "status_effect_manager" not in _entity:
		return
	for effect : StatusEffectBase in _entity.status_effect_manager.timed_effects:
		if effect.name == StatusEffectNames.MARK:
			var consumed_stacks : int = effect.stacks
			_entity.status_effect_manager.timed_effects.erase(effect)
			_entity.status_effect_manager.refresh_color_overlay()
			if "health_component" in _entity:
				_entity.health_component.take_damage(consumed_stacks)
				if "sprite_manager" in _entity and _entity.sprite_manager:
					_entity.sprite_manager.damage_flash()
			if StatCalculator.mark_to_orb():
				_spawn_orbs(_entity, consumed_stacks)
			break


func _spawn_orbs(_entity: Node3D, count: int) -> void:
	var xp_spawner_scene : PackedScene = load("res://Collectibles/xp_spawner.tscn")
	var xp_spawner : Node3D = xp_spawner_scene.instantiate()
	_entity.get_parent().add_child(xp_spawner)
	xp_spawner.global_transform.origin = _entity.global_transform.origin
	xp_spawner.setup_outwards(count, GlobalStats.player, CollectibleSpawner.OrbType.TIME, GlobalStats.player.get_floor())


func get_color_overlay() -> Color:
	var t : float = float(stacks - 1) / float(max(max_stacks - 1, 1))
	return COLOR_MIN.lerp(COLOR_MAX, clamp(t, 0.0, 1.0))
