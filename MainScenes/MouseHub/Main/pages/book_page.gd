extends Control
class_name BookPage

@onready var page_number_left_label: RichTextLabel = $LeftPage/PageNumberLabel
@onready var page_number_right_label: RichTextLabel = $RightPage/PageNumberLabel

func set_page_number(index: int) -> void:
	var left_number: int = index * 2 + 1
	var right_number: int = left_number + 1

	page_number_left_label.text = "pg %d" % left_number
	page_number_right_label.text = "pg %d" % right_number
