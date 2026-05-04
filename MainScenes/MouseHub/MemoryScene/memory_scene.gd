extends Control

@export var sticker_detail_scene : Control
@export var sticker_container : Control
@export var sticker_scene : PackedScene
@export var sticker_view : Control


var sticker_instances : Array[Sticker] = []

func _ready() -> void:
	setup()

func setup() -> void:
	clear_stickers()
	for memory_name : StringName in GameConstants.MEMORY_DATA.keys():
		DebugLog.dbg_from(self, "Setting up sticker for memory: " + str(memory_name))
		var sticker_instance : Sticker = sticker_scene.instantiate() as Sticker
		sticker_instance.setup(memory_name, self)
		sticker_container.add_child(sticker_instance)
		sticker_instances.append(sticker_instance)
	sticker_view.show()


func open_sticker_detail(memory_data : MemoryData) -> void:
	sticker_detail_scene.setup(memory_data, self)
	sticker_detail_scene.show()
	sticker_view.hide()

func close_sticker_detail() -> void:
	sticker_detail_scene.hide()	
	sticker_view.show()

func clear_stickers() -> void:
	for sticker in sticker_instances:
		sticker.queue_free()
	sticker_instances.clear()
