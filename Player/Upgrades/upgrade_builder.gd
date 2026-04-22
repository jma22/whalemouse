extends RefCounted
class_name UpgradeBuilder

var _internal_name: String
var _display_name: String
var _pool: StringName = UpgradePool.BLESSING
var _description_func: Callable
var _effects: Array[UpgradeEffect] = []
var _base_augment: int = 0
var _weight: float = 1.0
var _prereqs: Array[StringName] = []
var _tags: Array[StringName] = []

func _init(internal_name: String, display_name: String) -> void:
	_internal_name = internal_name
	_display_name = display_name

func pool(p: StringName) -> UpgradeBuilder:
	_pool = p
	return self

func description_fn(fn: Callable) -> UpgradeBuilder:
	_description_func = fn
	return self

func effect(e: UpgradeEffect) -> UpgradeBuilder:
	_effects.append(e)
	return self

func effects(es: Array[UpgradeEffect]) -> UpgradeBuilder:
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
	_tags = names
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
	return upgrade

func register() -> UpgradeData:
	var upgrade: UpgradeData = build()
	UpgradeRegistry.register(upgrade)
	return upgrade
