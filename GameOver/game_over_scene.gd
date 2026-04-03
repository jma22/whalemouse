extends Node3D

@export var text_label: RichTextLabel

func setup() -> void:
	display_stats()


func display_stats() -> void:
	text_label.clear()
	var stats : Dictionary = GlobalStats.total_stats
	for stat_name in stats.keys():
		text_label.text += stat_name + ": " + str(stats[stat_name]) + "\n"
