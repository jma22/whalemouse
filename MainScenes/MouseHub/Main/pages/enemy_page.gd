# enemy page
extends BookPage

@onready var creature_sprite: TextureRect = $LeftPage/CreatureSprite
@onready var name_label: TextTemplate = $LeftPage/NameLabel
@onready var description_label: RichTextLabel = $LeftPage/DescriptionLabel
@onready var lore_label: RichTextLabel = $RightPage/LoreLabel

func setup(data: Dictionary) -> void:
	name_label.set_values([data.name])
	description_label.text = data.description
	creature_sprite.texture = data.texture
	lore_label.text = data.lore
