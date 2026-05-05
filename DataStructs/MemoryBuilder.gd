extends RefCounted
class_name MemoryBuilder


class UnlockableBuilder extends RefCounted:
	var _parent: MemoryBuilder
	var _name: String
	var _illustration_path: String = ""
	var _illustration_description: String = ""
	var _cost: CostData
	var _gated_upgrades: Array[StringName] = []

	func _init(parent: MemoryBuilder, unlockable_name: String) -> void:
		_parent = parent
		_name = unlockable_name
		_cost = CostData.new()

	func illustration(path: String, desc: String = "") -> UnlockableBuilder:
		_illustration_path = path
		_illustration_description = desc
		return self

	func cost(currency: StringName, amount: int) -> UnlockableBuilder:
		_cost.add_cost(currency, amount)
		return self

	func gates(upgrades: Array[StringName]) -> UnlockableBuilder:
		_gated_upgrades = upgrades
		return self

	func end_unlockable() -> MemoryBuilder:
		var u := MemoryUnlockable.new()
		u.name = _name
		u.cost = _cost
		u.illustration_path = _illustration_path
		u.illustration_description = _illustration_description
		u.gated_upgrades = _gated_upgrades
		_parent._attach_unlockable(u)
		return _parent


var _name: String
var _sticker_sprite_path: String = ""
var _sticker_description: String = ""
var _cost: CostData
var _gated_upgrades: Array[StringName] = []
var _unlockables: Array[MemoryUnlockable] = []


func _init(memory_name: String) -> void:
	_name = memory_name
	_cost = CostData.new()


func sticker_sprite(path: String) -> MemoryBuilder:
	_sticker_sprite_path = path
	return self


func description(text: String) -> MemoryBuilder:
	_sticker_description = text
	return self


func cost(currency: StringName, amount: int) -> MemoryBuilder:
	_cost.add_cost(currency, amount)
	return self


func gates(upgrades: Array[StringName]) -> MemoryBuilder:
	_gated_upgrades = upgrades
	return self


func add_unlockable(unlockable_name: String) -> UnlockableBuilder:
	return UnlockableBuilder.new(self, unlockable_name)


func _attach_unlockable(u: MemoryUnlockable) -> void:
	u.parent_name = _name
	u.index = _unlockables.size()
	_unlockables.append(u)


func register() -> MemoryData:
	var data := MemoryData.new()
	data.name = _name
	data.cost = _cost
	data.sticker_sprite_path = _sticker_sprite_path
	data.sticker_description = _sticker_description
	data.gated_upgrades = _gated_upgrades
	data.unlockables = _unlockables
	GameConstants.register(_name, data)
	return data
