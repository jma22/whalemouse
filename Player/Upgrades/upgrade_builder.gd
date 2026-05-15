extends RefCounted
class_name UpgradeBuilder

var _internal_name: String
var _display_name: String
var _pool: StringName = UpgradePool.BLESSING
var _description_func: Callable
var _effects: Array[Callable] = []
var _base_augment: int = 0
var _weight: float = 1.0
var _prereqs: Array[StringName] = []
var _tags: Array[StringName] = []
var _max_stacks: int = 0
var _unlock_condition: Callable

func _init(internal_name: String, display_name: String) -> void:
	_internal_name = internal_name
	_display_name = display_name

func pool(p: StringName) -> UpgradeBuilder:
	_pool = p
	return self

func description_fn(fn: Callable) -> UpgradeBuilder:
	_description_func = fn
	return self

func effect(e: Callable) -> UpgradeBuilder:
	_effects.append(e)
	return self

func effects(es: Array[Callable]) -> UpgradeBuilder:
	_effects.append_array(es)
	return self

func augment(amount: int) -> UpgradeBuilder:
	_base_augment = amount
	return self

func weight(w: float) -> UpgradeBuilder:
	_weight = w
	return self

func prereqs(names: Array[StringName]) -> UpgradeBuilder:
	_prereqs = names
	return self

func tags(names: Array[StringName]) -> UpgradeBuilder:
	_tags.append_array(names)
	return self

func tag(name: StringName) -> UpgradeBuilder:
	_tags.append(name)
	return self

func limit_stacks(amount: int) -> UpgradeBuilder:
	_max_stacks = amount
	return self

func unlocks_after(condition: Callable) -> UpgradeBuilder:
	_unlock_condition = condition
	return self

func build() -> UpgradeData:
	var upgrade: UpgradeData = UpgradeData.new(
		_internal_name,
		_display_name,
		_pool,
		_description_func,
		_effects)
	upgrade.base_augment = _base_augment
	upgrade.weight = _weight
	upgrade.prereqs = _prereqs
	upgrade.tags = _tags
	upgrade.max_stacks = _max_stacks
	upgrade.unlock_condition = _unlock_condition

	if UpgradeTag.SOURCE in _tags:
		upgrade.weight *= 0.75
	if UpgradeTag.DROPS_ORBS in _tags:
		upgrade.weight *= 1.5
	
	return upgrade

func register() -> UpgradeData:
	var upgrade: UpgradeData = build()
	UpgradeRegistry.register(upgrade)
	return upgrade
