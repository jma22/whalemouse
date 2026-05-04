extends Control

@export var back_button : Button
@export var sticker_name_label : RichTextLabel
@export var sticker_description_label : RichTextLabel
@export var sticker_sprite : TextureRect
## var illustration : Illustration

func setup(memory_data : MemoryData) -> void:
	sticker_name_label.text = memory_data.name
	sticker_description_label.text = memory_data.sticker_description
	sticker_sprite.texture = load(memory_data.sticker_sprite_path)
	back_button.pressed.connect(close)
	show()

func close() -> void:
	hide()