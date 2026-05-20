# chapter page
extends BookPage

@onready var title_label: RichTextLabel = $LeftPage/TitleLabel
@onready var description_label: RichTextLabel = $LeftPage/DescriptionLabel

func setup(data: Dictionary) -> void:
	title_label.text = data.title
	description_label.text = data.description
