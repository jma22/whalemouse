extends MapManagerBase
class_name ShrineMapManager

@export var shrines : Array[Node3D]

		
func start_room (wave : WaveInfo) -> void:
	super(wave)
	var upgradesList = get_upgrades_from_ids(wave_info.blessings)
	var blessings = get_randomized_upgrades(upgradesList, true, 2)
	set_shrines(blessings)
	player.gain_status_effect(StatusEffect.create("freeze", 4.0))

func get_randomized_upgrades(upgrades: Array[UpgradeData], isBlessing: bool, amount: int) -> Array[UpgradeData]:
	var randomized: Array[UpgradeData] = []

	# Collect only blessings
	for key in upgrades:
		var upgrade: UpgradeData = upgrades[key]
		if upgrade.isBlessing == isBlessing:
			randomized.append(upgrade)

	# Safety check
	if randomized.size() < amount:
		return randomized

	# Shuffle and take first the 2
	randomized.shuffle()
	return randomized.slice(0, amount)


func get_upgrades_from_ids(ids: Array[String]) -> Array[UpgradeData]:
	var result: Array[UpgradeData] = []

	for id in ids:
		var upgrade: UpgradeData = Upgrades.list.get(id)
		if upgrade != null:
			result.append(upgrade)

	return result

func set_shrines(blessings: Array[String]) -> void:
	for i in range(shrines.size()):
		if i >= blessings.size():
			shrines[i].setup("")	
			shrines[i].close_gateway()
		else:
			shrines[i].setup(blessings[i])
			shrines[i].open_gateway()


func map_cleared() -> bool:
	for shrine : Shrine in shrines:
		if shrine and shrine.activated:
			return true
	return false

func on_map_cleared() -> void:
	super()
	for shrine : Shrine in shrines:
		shrine.close_gateway()
