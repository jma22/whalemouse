class_name GameConstants

const BOSS_FRAGMENTS : StringName = &"boss_fragments"
const SMALL_FRAGMENTS : StringName = &"small_fragments"
const CURSED_FRAGMENTS : StringName = &"cursed_fragments"

static var MEMORY_DATA : Dictionary[StringName, MemoryData] = {}


static func _static_init() -> void:
	var memory1 : MemoryData = MemoryData.new()
	memory1.name = "Piranha"
	var cost : CostData = CostData.new()
	cost.add_cost(SMALL_FRAGMENTS, 10)
	memory1.gated_upgrade = "orb_weight"
	memory1.cost = cost
	memory1.sticker_sprite_path = "res://MainScenes/MouseHub/MemoryScene/MainStickers/sticker1.png"
	register(memory1.name, memory1)


static func register(memory_name: StringName, data: MemoryData) -> void:
	MEMORY_DATA[memory_name] = data
