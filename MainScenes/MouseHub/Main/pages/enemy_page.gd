# enemy page
extends BookPage

@onready var creature_sprite: TextureRect = $LeftPage/CreatureSprite
@onready var name_label: RichTextLabel = $LeftPage/NameLabel
@onready var description_label: RichTextLabel = $LeftPage/DescriptionLabel

func setup(data: Dictionary) -> void:
	name_label.text = data.name
	description_label.text = data.description
	creature_sprite.texture = data.texture
