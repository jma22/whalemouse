extends Control

@export var back_button : Button
@export var sticker_name_label : RichTextLabel
@export var sticker_description_label : RichTextLabel
@export var sticker_sprite : TextureRect
@export var illustration_scene : PackedScene
@export var illustration_container : Control


var memory_scene : Control
var memory_data : MemoryData
## var illustration : Illustration

func setup(memory_data : MemoryData, memory_scene : Control) -> void:
	self.memory_data = memory_data
	self.memory_scene = memory_scene

	clear_illustrations()
	sticker_name_label.text = memory_data.name
	sticker_description_label.text = memory_data.sticker_description
	sticker_sprite.texture = load(memory_data.sticker_sprite_path)
	back_button.pressed.connect(close)
	for unlockable in memory_data.unlockables:
		DebugLog.dbg_from(self, "Memory has unlockable: " + unlockable.name)
		var illustration : UnlockIllustration = illustration_scene.instantiate() as UnlockIllustration
		illustration_container.add_child(illustration)
		illustration.setup(unlockable, self)
	show()

func close() -> void:
	memory_scene.close_sticker_detail()

func clear_illustrations() -> void:
	for child in illustration_container.get_children():
		child.queue_free()
