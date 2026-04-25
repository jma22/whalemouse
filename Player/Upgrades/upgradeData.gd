extends Choice
class_name UpgradeData

var internal_name: String
var blessing_type: String
var base_augment: int = 0
var max_stacks: int = 0
var weight: float = 1.0
var prereqs: Array[StringName] = []
var tags: Array[StringName] = []
var unlock_condition: Callable

func _init(_internal_name: String = "", _display_name: String = "", _blessing_type: String = "", _description_func: Callable = Callable(), _effects: Array[Callable] = []) -> void:
	super(_display_name, _description_func)
	internal_name = _internal_name
	blessing_type = _blessing_type
	self.effects = _effects

func has_tag(tag: StringName) -> bool:
	return tag in tags

func apply() -> void:
	UpgradePicker.chosen_upgrade(self)
	super.apply()

func is_blessing() -> bool:
	return blessing_type == UpgradePool.BLESSING or blessing_type == UpgradePool.BOSS_BLESSING

func get_icon_path() -> String:
	return Choice.get_icon_path_for(internal_name)

func get_supplement_info() -> String:
	var info : Array[String] = []
	for tag in tags:
		var description := Keywords.apply(UpgradeTag.get_description_for_tag(tag))
		if description != "":
			info.append(description)
	# remove trailing newline
	return "\n".join(info).rstrip("\n")

