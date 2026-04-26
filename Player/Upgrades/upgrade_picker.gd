extends Object
class_name UpgradePicker


static var choice_history: Array[StringName] = []
static var chosen_tags: Array[StringName] = []


static func _dbg(string : String) -> void:
	DebugLog.dbg("UpgradePicker", string)

static func has_chosen_tag(tag: StringName) -> bool:
	return tag in chosen_tags

static func times_chosen(internal_name: StringName) -> int:
	return choice_history.count(internal_name)

static func reset() -> void:
	choice_history.clear()
	chosen_tags.clear()


static func is_eligible(upgrade: UpgradeData, extra_reqs : Array[StringName]) -> bool:
	var times: int = times_chosen(upgrade.internal_name)

	if UpgradeTag.ONETIME in upgrade.tags and times >= 1:
		_dbg("Ineligible for %s because it's one-time and we've already chosen it %d times" % [upgrade.internal_name, times])
		return false
	if upgrade.max_stacks > 0 and times >= upgrade.max_stacks:
		_dbg("Ineligible for %s because we've already chosen it %d times and the max is %d" % [upgrade.internal_name, times, upgrade.max_stacks])
		return false

	if upgrade.unlock_condition.is_valid() and not GameData.is_unlocked(upgrade.internal_name):
		_dbg("Ineligible for %s because it is locked" % upgrade.internal_name)
		return false

	for prereq: StringName in upgrade.prereqs:
		# var stat_ok: bool = GlobalStats.current_run_stats.get(prereq, 0) > 0
		# var name_ok: bool = has_chosen(prereq)
		var tag_ok: bool = has_chosen_tag(prereq)
		if not (tag_ok):
			_dbg("Ineligible for %s because we haven't chosen required tag %s" % [upgrade.internal_name, prereq])
			return false
	
	for tag: StringName in extra_reqs:
		if not upgrade.tags.has(tag):
			_dbg("Ineligible for %s because we need tag %s but it only has tags %s" % [upgrade.internal_name, tag, upgrade.tags])
			return false

	return true

static func eligible_in_pool(pool: String, need_tags: Array[StringName], exclude: Array[StringName] = []) -> Array[UpgradeData]:
	var result: Array[UpgradeData] = []
	for upgrade: UpgradeData in UpgradeRegistry.all():
		if upgrade.blessing_type == pool and is_eligible(upgrade, need_tags) and not (upgrade.internal_name in exclude):
			result.append(upgrade)
	var total_w: float = 0.0
	for u: UpgradeData in result:
		total_w += u.weight
	_dbg("pool=[%s] need_tags=%s  %d eligible:" % [pool, need_tags, result.size()])
	for u: UpgradeData in result:
		var pct: float = (u.weight / total_w * 100.0) if total_w > 0.0 else 0.0
		_dbg("  %-30s  w=%.2f  (%.1f%%)" % [u.internal_name, u.weight, pct])
	return result

static func pick(pool: String, amount: int, need_tags: Array[StringName], exclude: Array[StringName] = []) -> Array[UpgradeData]:
	## exclude is for internal_names, not tags
	var candidates: Array[UpgradeData] = eligible_in_pool(pool, need_tags, exclude)
	if candidates.size() <= amount:
		_dbg("[ERROR]Not enough candidates in pool %s, need %d but only have %d. Returning all." % [pool, amount, candidates.size()])
		return candidates
	var picks := _weighted_sample(candidates, amount)
	_dbg("pick result: %s" % str(picks.map(func(u: UpgradeData) -> String: return u.internal_name)))
	return picks

static func pick_or(pool: String, amount: int, at_least_one_tags: Array[StringName], exclude: Array[StringName] = []) -> Array[UpgradeData]:
	var candidates: Array[UpgradeData] = []
	for tag in at_least_one_tags:
		candidates += eligible_in_pool(pool, [tag], exclude)
	if candidates.size() == 0:
		_dbg("No candidates in pool %s with tags %s" % [pool, at_least_one_tags])
		return candidates
	return _weighted_sample(candidates, amount)

static func _weighted_sample(candidates: Array[UpgradeData], amount: int) -> Array[UpgradeData]:
	var pool: Array[UpgradeData] = candidates.duplicate()
	var result: Array[UpgradeData] = []
	for i in amount:
		if pool.is_empty():
			break
		var total_weight: float = 0.0
		for u: UpgradeData in pool:
			total_weight += u.weight
		if total_weight <= 0.0:
			var idx: int = randi() % pool.size()
			result.append(pool[idx])
			_dbg("  draw %d: (zero weights) random → %s" % [result.size(), pool[idx].internal_name])
			pool.remove_at(idx)
			continue
		var roll: float = randf() * total_weight
		var cumulative: float = 0.0
		for j in pool.size():
			cumulative += pool[j].weight
			if roll <= cumulative:
				result.append(pool[j])
				_dbg("  draw %d: roll=%.3f / %.3f → %s" % [result.size(), roll, total_weight, pool[j].internal_name])
				pool.remove_at(j)
				break
	return result


static func chosen_upgrade(upgrade_data: UpgradeData) -> void:
	choice_history.append(upgrade_data.internal_name)
	for tag: StringName in upgrade_data.tags:
		if not (tag in chosen_tags):
			chosen_tags.append(tag)