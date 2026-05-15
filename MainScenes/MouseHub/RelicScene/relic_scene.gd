extends Control

const RELIC_STICKER_SCENE : PackedScene = preload("res://MainScenes/MouseHub/RelicScene/relic_sticker.tscn")

@export var grid_container : GridContainer
var sticker_nodes : Array[RelicSticker] = []

func _ready() -> void:
	clear_all()	
	for upgrade : UpgradeData in UpgradeRegistry.all():
		var sticker : RelicSticker = RELIC_STICKER_SCENE.instantiate()
		grid_container.add_child(sticker)
		sticker.setup(upgrade.internal_name)
		sticker_nodes.append(sticker)

func clear_all() -> void:
	for sticker in sticker_nodes:
		sticker.queue_free()
	sticker_nodes.clear()