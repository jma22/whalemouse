class_name GameConstants

const BOSS_FRAGMENTS : StringName = &"boss_fragments"
const SMALL_FRAGMENTS : StringName = &"small_fragments"
const CURSED_FRAGMENTS : StringName = &"cursed_fragments"

static var MEMORY_DATA : Dictionary[StringName, MemoryData] = {}
static var MEMORY_GATED_UPGRADES : Dictionary[StringName, bool] = {}


static func _static_init() -> void:
	MemoryBuilder.new("Piranha") \
		.sticker_sprite("res://MainScenes/MouseHub/MemoryScene/MainStickers/sticker1.png") \
		.cost(SMALL_FRAGMENTS, 10) \
		.gates([&"orb_weight"]) \
		.add_unlockable("Piranha Upgrade") \
			.illustration("res://MainScenes/MouseHub/MemoryScene/Illustrations/ill1.png", "Unlock") \
			.cost(SMALL_FRAGMENTS, 5) \
			.gates([&"deaths_dance"]) \
			.end_unlockable() \
		.register()

	_build_gated_upgrade_index()


static func register(memory_name: StringName, data: MemoryData) -> void:
	MEMORY_DATA[memory_name] = data


static func _build_gated_upgrade_index() -> void:
	MEMORY_GATED_UPGRADES.clear()
	for memory: MemoryData in MEMORY_DATA.values():
		for upgrade_name: StringName in memory.gated_upgrades:
			MEMORY_GATED_UPGRADES[upgrade_name] = true
		for unlockable: MemoryUnlockable in memory.unlockables:
			for upgrade_name: StringName in unlockable.gated_upgrades:
				MEMORY_GATED_UPGRADES[upgrade_name] = true


static func is_memory_gated(upgrade_name: String) -> bool:
	return MEMORY_GATED_UPGRADES.has(StringName(upgrade_name))
