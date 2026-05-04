class_name GameConstants

const BOSS_FRAGMENTS : StringName = &"boss_fragments"
const SMALL_FRAGMENTS : StringName = &"small_fragments"
const CURSED_FRAGMENTS : StringName = &"cursed_fragments"

static var MEMORY_DATA : Dictionary[StringName, MemoryData] = {}


static func _static_init() -> void:
	var unlockable1 : MemoryUnlockable = MemoryUnlockable.new()
	unlockable1.name = "Piranha Upgrade"
	var cost : CostData = CostData.new()
	cost.add_cost(SMALL_FRAGMENTS, 5)
	unlockable1.cost = cost
	unlockable1.illustration_path = "res://MainScenes/MouseHub/MemoryScene/Illustrations/ill1.png"
	unlockable1.illustration_description = "Unlock"
	unlockable1.gated_upgrade = "deaths_dance"
	unlockable1.parent_name = "Piranha"
	unlockable1.index = 0

	var memory1 : MemoryData = MemoryData.new()
	memory1.name = "Piranha"
	var cost2 : CostData = CostData.new()
	cost2.add_cost(SMALL_FRAGMENTS, 10)
	memory1.gated_upgrade = "orb_weight"
	memory1.cost = cost2
	memory1.sticker_sprite_path = "res://MainScenes/MouseHub/MemoryScene/MainStickers/sticker1.png"
	memory1.unlockables.append(unlockable1)
	register(memory1.name, memory1)


static func register(memory_name: StringName, data: MemoryData) -> void:
	MEMORY_DATA[memory_name] = data
