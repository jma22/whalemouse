extends Node3D

class_name StatusEffectManager
var status_effects : Dictionary = {}
var timed_effects : Array[StatusEffectBase] = []

@export var entity : Node3D
var is_enemy : bool = false
# Called when the node enters the scene tree for the first time.

func setup(player_node : Node3D) -> void:
	entity = player_node
	is_enemy = entity is EnemyBase

func _process(delta: float) -> void:
	for effect : StatusEffectBase in timed_effects:
		effect.tick_effect(delta)
		if effect.time_remaining <= 0:
			timed_effects.erase(effect)
			print("Lost status effect: ", effect.name)

func gain_status_effect(effect : StatusEffectBase, source : Object) -> void:
	print("Gained status effect: ", effect.name, " from source: ", source)
	if effect.name == "haste":
		TutorialManager.show_tutorial(TutorialManager.TutorialEnum.BLEED)
	if effect.is_conditional:
		var id : int = source.get_instance_id()
		if id not in status_effects:
			status_effects[id] = []
		status_effects[id].append(effect)
		
	else:
		for existing_effect : StatusEffectBase in timed_effects:
			if existing_effect.name == effect.name:
				existing_effect.time_remaining += effect.duration
				existing_effect.duration += effect.duration
				return
		timed_effects.append(effect)


func lose_status_effect(effect : StatusEffectBase, source : Object) -> void:
	if effect.is_conditional:
		var id : int = source.get_instance_id()
		if id in status_effects:
			var effects : Array = status_effects[id]
			for existing_effect : StatusEffectBase in effects:
				if existing_effect == effect:
					effects.erase(existing_effect)
					print("Lost status effect: ", effect.name, " from source: ", source)
					if effects.is_empty():
						status_effects.erase(id)
					return
	else:
		for existing_effect : StatusEffectBase in status_effects:
			if existing_effect.name == effect.name:
				status_effects.erase(existing_effect)
				print("Lost status effect: ", effect.name)
				return

func clear_effects() -> void:
	status_effects.clear()	
	timed_effects.clear()

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

func get_status_time_multiplier() -> float:
	var multiplier : float = 1.0
	for effect : StatusEffectBase in get_deduped_list():
		multiplier *= effect.get_multiplier()
	return multiplier

func has_status_effect(effect_name: String = "") -> bool:
	if effect_name == "":
		return get_deduped_list().size() > 0
	for effect : StatusEffectBase in get_deduped_list():
		if effect.name == effect_name:
			return true
	return false
