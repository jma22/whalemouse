extends Object
class_name UpgradeRegistry

static var _by_name: Dictionary = {}

static func register(upgrade: UpgradeData) -> void:
	_by_name[upgrade.internal_name] = upgrade
	# print("Current registry: %s" % _by_name)

static func get_by_name(internal_name: String) -> UpgradeData:
	return _by_name.get(internal_name, null)

# static func has(internal_name: String) -> bool:
# 	return _by_name.has(internal_name)

# static func erase(internal_name: String) -> void:
# 	_by_name.erase(internal_name)

static func all() -> Array[UpgradeData]:
	var result: Array[UpgradeData] = []
	for upgrade: UpgradeData in _by_name.values():
		result.append(upgrade)
	return result

# static func all_in_pools(pools: Array[StringName]) -> Array[UpgradeData]:
# 	var result: Array[UpgradeData] = []
# 	for upgrade: UpgradeData in _by_name.values():
# 		if upgrade.blessing_type in pools:
# 			result.append(upgrade)
# 	return result
