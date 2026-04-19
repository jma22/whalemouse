extends Node3D

class_name StatusEffectManager
var status_effects : Dictionary = {}
var timed_effects : Array[StatusEffect] = []
# Called when the node enters the scene tree for the first time.


func _process(delta: float) -> void:
	for effect : StatusEffect in timed_effects:
		effect.tick_effect(delta)
		if effect.time_remaining <= 0:
			timed_effects.erase(effect)
			print("Lost status effect: ", effect.name)

func gain_status_effect(effect : StatusEffect, source : Object) -> void:
	if effect.name == "haste":
		TutorialManager.show_tutorial(TutorialManager.TutorialEnum.BLEED)
	if effect.is_conditional:
		var id : int = source.get_instance_id()
		if id not in status_effects:
			status_effects[id] = []
		status_effects[id].append(effect)
		
	else:
		for existing_effect : StatusEffect in timed_effects:
			if existing_effect.name == effect.name:
				existing_effect.time_remaining += effect.duration
				existing_effect.duration += effect.duration
				return
		timed_effects.append(effect)


func lose_status_effect(effect : StatusEffect, source : Object) -> void:
	if effect.is_conditional:
		var id : int = source.get_instance_id()
		if id in status_effects: 
			var effects : Array = status_effects[id]
			for existing_effect : StatusEffect in effects:
				if existing_effect == effect:
					effects.erase(existing_effect)
					print("Lost status effect: ", effect.name, " from source: ", source)
					if effects.is_empty():
						status_effects.erase(id)
					return
	else:
		for existing_effect : StatusEffect in status_effects:
			if existing_effect.name == effect.name:
				status_effects.erase(existing_effect)
				print("Lost status effect: ", effect.name)
				return

func clear_effects() -> void:
	status_effects.clear()	
	timed_effects.clear()

func get_deduped_list() -> Array[StatusEffect]:
	var deduped : Array[StatusEffect] = []
	var seen_names : Array[String] = []
	for effect_list : Array in status_effects.values():
		for effect : StatusEffect in effect_list:
			if effect.name not in seen_names:
				deduped.append(effect)
				seen_names.append(effect.name)

	for effect : StatusEffect in timed_effects:
		if effect.name not in seen_names:
			deduped.append(effect)
			seen_names.append(effect.name)
	
	return deduped

func get_status_time_multiplier() -> float:
	var multiplier : float = 1.0
	for effect : StatusEffect in get_deduped_list():
		multiplier *= effect.get_multiplier()
	return multiplier

func has_status_effect(effect_name: String = "") -> bool:
	if effect_name == "":
		return get_deduped_list().size() > 0
	for effect : StatusEffect in get_deduped_list():
		if effect.name == effect_name:
			return true
	return false
