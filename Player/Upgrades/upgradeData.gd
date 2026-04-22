extends Choice
class_name UpgradeData

var internal_name: String
var blessing_type: String
var effects : Array[UpgradeEffect] = []
var base_augment: int = 0
var weight: float = 1.0
var prereqs: Array[StringName] = []
var tags: Array[StringName] = []

func _init(_internal_name : String = "", _display_name: String = "", _blessing_type: String = "", _description_func: Callable = Callable(), _effects: Array[UpgradeEffect] = []) -> void:
	super(_display_name, _description_func)
	internal_name = _internal_name
	blessing_type = _blessing_type
	effects = _effects

static func is_blessing_pool(pool: StringName) -> bool:
	return pool in UpgradePool.BLESSING_POOLS

func apply() -> void:
	Upgrades.chosen_upgrade(self)
	for effect: UpgradeEffect in effects:
		effect.apply()

func affects_stat(stat_name: StringName) -> bool:
	for effect: UpgradeEffect in effects:
		if effect.affects_stat(stat_name):
			return true
	return false

func is_blessing() -> bool:
	return UpgradeData.is_blessing_pool(blessing_type)

func get_icon_path() -> String:
	return Choice.get_icon_path_for(internal_name)

func has_belugas_blessing() -> bool:
	return internal_name == "time_tick_level"


# --- decorators: return a transient UpgradeData with extra effect + wrapped description ---

func with_beluga_blessing() -> UpgradeData:
	var new_effects: Array[UpgradeEffect] = effects.duplicate()
	new_effects.append(IncreaseBossStatEffect.new(&"num_blessings"))
	var orig: UpgradeData = self
	var new_desc: Callable = func() -> String:
		return orig.get_description() + "\n[rainbow freq=0.6 sat=0.8 val=1.0 speed=0.4]Beluga's Blessing[/rainbow]"
	return UpgradeData.new(internal_name, display_name + "+", blessing_type, new_desc, new_effects)

func with_angler_curse() -> UpgradeData:
	var new_effects: Array[UpgradeEffect] = effects.duplicate()
	new_effects.append(IncreaseBossStatEffect.new(&"num_curses"))
	var orig: UpgradeData = self
	var new_desc: Callable = func() -> String:
		return orig.get_description() + "\n[pulse freq=2.0 color=#960028FF ease=-3.0]Angler's Curse[/pulse]"
	return UpgradeData.new(internal_name, display_name + "+", blessing_type, new_desc, new_effects)

func with_augment_cost() -> UpgradeData:
	var new_effects: Array[UpgradeEffect] = effects.duplicate()
	var scaled_cost: int = _scale_augment_cost(base_augment)
	var is_healing: bool = base_augment > 0
	if is_healing:
		new_effects.append(HealFlatEffect.new(scaled_cost))
	else:
		new_effects.append(DamageFlatEffect.new(scaled_cost))
	var orig: UpgradeData = self
	var augment_val: int = base_augment
	var new_desc: Callable = func() -> String:
		if augment_val < 0:
			return orig.get_description() + "\n[color=#FF0000]Lose " + str(scaled_cost) + "[/color]"
		elif augment_val > 0:
			return orig.get_description() + "\n[color=#00FF00]Heal " + str(scaled_cost) + "[/color]"
		return orig.get_description()
	return UpgradeData.new(internal_name, display_name + "+", blessing_type, new_desc, new_effects)

func with_harder_curse() -> UpgradeData:
	var new_effects: Array[UpgradeEffect] = effects.duplicate()
	var scaled_damage: int = _scale_curse_damage(base_augment)
	new_effects.append(DamageFlatEffect.new(scaled_damage))
	var orig: UpgradeData = self
	var new_desc: Callable = func() -> String:
		return orig.get_description() + "\n[color=#FF0000]Lose " + str(scaled_damage) + "[/color]"
	return UpgradeData.new(internal_name, display_name + "+", blessing_type, new_desc, new_effects)


static func _scale_augment_cost(flat: int) -> int:
	var num: int = flat
	if num < 0:
		num += randi_range(-3, 3)
	else:
		num += randi_range(-2, 2)
	num = max(0, num)
	return floor(num)

static func _scale_curse_damage(amount: int) -> int:
	var num: int = amount
	num += randi_range(-2, 2)
	num = max(0, num)
	return floor(num)
