extends Node3D

class_name StatusEffectManager
var status_effects : Dictionary = {}
var timed_effects : Array[StatusEffectBase] = []

@export var entity : Node3D
var is_enemy : bool = false

func _dbg(msg: String) -> void:
	DebugLog.dbg("StatusEffectManager", msg)

func setup(player_node : Node3D) -> void:
	entity = player_node
	is_enemy = entity is EnemyBase

func _process(delta: float) -> void:
	var last_damaging_effect : StatusEffectBase = null
	var any_expired : bool = false
	for effect : StatusEffectBase in timed_effects.duplicate():
		effect.on_dot_tick(entity, delta)
		if not effect.persists_forever:
			effect.tick_effect(delta)
		if not effect.persists_forever and effect.time_remaining <= 0:
			last_damaging_effect = effect
			any_expired = true
			if effect.on_expired(entity):
				timed_effects.erase(effect)
				_dbg("expired and removed: %s" % effect.name)

	if any_expired:
		refresh_color_overlay()

	if is_enemy and entity:
		var enemy : EnemyBase = entity as EnemyBase
		if enemy and not enemy.is_dead and enemy.health_component.is_dead() and last_damaging_effect:
			_dbg("entity died via effect: %s" % last_damaging_effect.name)
			last_damaging_effect.on_killed_by_effect(enemy)
			var info : DamageInfo = DamageInfo.new()
			info.amount = enemy.health_component.current_health
			info.damage_type = DamageInfo.DamageType.POISON ## buggy
			info.source = last_damaging_effect.source
			info.was_marked = false
			enemy.on_die(info)

func gain_status_effect(effect : StatusEffectBase, source_entity : Object) -> void:
	_dbg("gained %s from %s" % [effect.name, DebugLog.entity_name(source_entity)])
	## only conditionals need entity
	if effect.is_conditional:
		assert(source_entity != null)
	effect.source = source_entity
	if effect.name == StatusEffectNames.HASTE:
		TutorialManager.show_tutorial(TutorialManager.TutorialEnum.BLEED)
	if effect.is_conditional:
		var id : int = source_entity.get_instance_id()
		if id not in status_effects:
			status_effects[id] = []
		status_effects[id].append(effect)
		effect.on_applied(entity)
		refresh_color_overlay()

	else:
		for existing_effect : StatusEffectBase in timed_effects:
			if existing_effect.name == effect.name:
				_dbg("stacking %s" % effect.name)
				effect.stack_with(existing_effect)
				effect.on_applied(entity)
				return
		timed_effects.append(effect)
		effect.on_applied(entity)
		refresh_color_overlay()


func lose_status_effect(effect : StatusEffectBase, source_entity : Object) -> void:
	if effect.is_conditional:
		var id : int = source_entity.get_instance_id()
		if id in status_effects:
			var effects : Array = status_effects[id]
			for existing_effect : StatusEffectBase in effects:
				if existing_effect == effect:
					effects.erase(existing_effect)
					_dbg("lost conditional %s from %s" % [effect.name, DebugLog.entity_name(source_entity)])
					if effects.is_empty():
						status_effects.erase(id)
					refresh_color_overlay()
	else:
		for existing_effect : StatusEffectBase in status_effects:
			if existing_effect.name == effect.name:
				status_effects.erase(existing_effect)
				_dbg("lost %s" % effect.name)
				refresh_color_overlay()


func clear_effects() -> void:
	status_effects.clear()
	timed_effects.clear()
	refresh_color_overlay()

func get_deduped_list() -> Array[StatusEffectBase]:
	var deduped : Array[StatusEffectBase] = []
	var seen_names : Array[String] = []
	for effect_list : Array in status_effects.values():
		for effect : StatusEffectBase in effect_list:
			if effect.name not in seen_names:
				deduped.append(effect)
				seen_names.append(effect.name)

	for effect : StatusEffectBase in timed_effects:
		if effect.name not in seen_names:
			deduped.append(effect)
			seen_names.append(effect.name)

	return deduped

func modify_time_delta(delta: float) -> float:
	for effect : StatusEffectBase in get_deduped_list():
		delta = effect.modify_time_delta(delta)
	return delta

func modify_incoming_damage(info: DamageInfo) -> void:
	for effect : StatusEffectBase in get_deduped_list():
		effect.modify_incoming_damage(info)

func get_speed_multiplier_from_status() -> float:
	var m : float = 1.0
	for effect : StatusEffectBase in get_deduped_list():
		m *= effect.get_speed_multiplier()
	return m

func get_attack_speed_multiplier() -> float:
	var m : float = 1.0
	for effect : StatusEffectBase in get_deduped_list():
		m *= effect.get_attack_speed_multiplier()
	return m

func get_projectile_flat() -> int:
	var total : int = 0
	for effect : StatusEffectBase in get_deduped_list():
		total += effect.get_projectile_flat()
	return total

func get_damage_multiplier() -> int:
	var m : int = 1
	for effect : StatusEffectBase in get_deduped_list():
		m *= effect.get_damage_multiplier()
	return m

func notify_hit_consumed(info: DamageInfo) -> void:
	_dbg("notify_hit_consumed dmg=%s" % info.amount)
	for effect : StatusEffectBase in get_deduped_list().duplicate():
		if effect.on_hit_consumed(entity, info):
			timed_effects.erase(effect)

# func notify_owner_killed(killer: Object) -> void:
# 	## ised for status
# 	for effect : StatusEffectBase in get_deduped_list():
# 		effect.on_owner_killed(entity, killer)

func notify_entity_died() -> void:
	_dbg("notify_entity_died")
	for effect : StatusEffectBase in get_deduped_list():
		effect.on_entity_died(entity)

func has_status_effect(effect_name: String = "") -> bool:
	if effect_name == "":
		return get_deduped_list().size() > 0
	for effect : StatusEffectBase in get_deduped_list():
		if effect.name == effect_name:
			return true
	return false


func refresh_color_overlay() -> void:
	var color : Color = Color(1, 1, 1)
	for effect : StatusEffectBase in get_deduped_list():
		var c : Color = effect.get_color_overlay()
		if c != Color(1, 1, 1):
			color = c
	entity.sprite_manager.set_modulate(color)
