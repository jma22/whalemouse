extends HBoxContainer

class_name BossInfoBar

@export var blessing_num : RichTextLabel
@export var curse_num : RichTextLabel

func sync_bar() -> void:
	blessing_num.text = str(GlobalStats.get_num_boss_blessings())
	curse_num.text = str(GlobalStats.get_num_boss_curses())
	
