extends Object
class_name UpgradePicker

static func is_eligible(upgrade: UpgradeData) -> bool:
	for prereq: StringName in upgrade.prereqs:
		if GlobalStats.current_run_stats.get(prereq, 0) <= 0:
			return false
	return true

static func eligible_in_pools(pools: Array[String]) -> Array[UpgradeData]:
	var result: Array[UpgradeData] = []
	for upgrade: UpgradeData in UpgradeRegistry.all():
		if upgrade.blessing_type in pools and is_eligible(upgrade):
			result.append(upgrade)
	return result

static func pick(pools: Array[String], amount: int) -> Array[UpgradeData]:
	var candidates: Array[UpgradeData] = eligible_in_pools(pools)
	if candidates.size() <= amount:
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
			pool.remove_at(idx)
			continue
		var roll: float = randf() * total_weight
		var cumulative: float = 0.0
		for j in pool.size():
			cumulative += pool[j].weight
			if roll <= cumulative:
				result.append(pool[j])
				pool.remove_at(j)
				break
	return result
