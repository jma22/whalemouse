extends HBoxContainer

class_name BlessingBar

@onready var icon_scene : PackedScene = preload("res://Icons/icon.tscn")
var icons : Array[Icon] = []

func sync_bar() -> void:
	reset()
	for stat: Dictionary in GlobalStats.get_current_stats():
		var icon = icon_scene.instantiate() as Icon
		var stat_name = stat.keys()[0]
		var stat_value = stat[stat_name]
		icon.setup(stat_name, stat_value)
		add_child(icon)
		icons.append(icon)

func reset() -> void:
	for icon in icons:
		icon.queue_free()
	icons.clear()
