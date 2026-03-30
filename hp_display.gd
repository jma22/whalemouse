extends Control
class_name HPDisplay


@export var hp_label : RichTextLabel

func lose_hp(amount: int, new_hp: int) -> void:
	refresh_hp(new_hp)

func gain_hp(amount: int, new_hp: int) -> void:
	refresh_hp(new_hp)

func refresh_hp(new_hp: int) -> void:
	hp_label.text = str(new_hp)
