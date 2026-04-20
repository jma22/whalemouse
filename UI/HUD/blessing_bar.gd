extends HBoxContainer

class_name BlessingBar

@export var icon_scene : PackedScene
var icons : Array[Icon] = []

func sync_bar() -> void:
	print("Syncing BlessingBar")
	reset()
	for augment_name : String in GlobalStats.wave_augments.keys():
		var augment_icon : Icon = icon_scene.instantiate() as Icon
		var duration : int = GlobalStats.wave_augments[augment_name]
		augment_icon.setup(augment_name, duration)
		add_child(augment_icon)
		icons.append(augment_icon)
		
	for stat: Dictionary in GlobalStats.get_current_stats():
		var icon : Icon = icon_scene.instantiate() as Icon
		var stat_name : String = stat.keys()[0]
		var stat_value : int = stat[stat_name]
		icon.setup(stat_name, stat_value)
		add_child(icon)
		icons.append(icon)
	


func reset() -> void:
	for icon in icons:
		icon.queue_free()
	icons.clear()
