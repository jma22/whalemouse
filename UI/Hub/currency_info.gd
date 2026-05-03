extends HBoxContainer

class_name CurrencyInfoBar

@export var blessing_num : RichTextLabel
@export var curse_num : RichTextLabel

func _ready() -> void:
	GlobalStats.boss_stat_changed.connect(_on_boss_stat_changed)

func _on_boss_stat_changed(_stat_name: StringName, _new_value: int) -> void:
	sync_bar()

func sync_bar() -> void:
	blessing_num.text = str(StatCalculator.get_num_boss_blessings())
	curse_num.text = str(StatCalculator.get_num_boss_curses())

