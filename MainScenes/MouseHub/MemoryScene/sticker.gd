extends Control
class_name Sticker


@export var texture_button : TextureButton
@export var cost_label : RichTextLabel

var sticker_name : String
var unlocked : bool = false
var memory_data : MemoryData
var memory_scene : Control

# func _ready() -> void:
# 	setup()

func setup(sticker_name : String, memory_scene : Control) -> void:
	self.sticker_name = sticker_name
	self.memory_scene = memory_scene
	memory_data = GameConstants.MEMORY_DATA[sticker_name]
	unlocked = GameData.is_memory_unlocked(sticker_name)

	texture_button.pressed.connect(on_texture_button_pressed)
	update_cost_label()



func on_texture_button_pressed() -> void:
	if unlocked:
		self.memory_scene.open_sticker_detail(memory_data)
	else:
		#check if player has enough currency to unlock
		var cost : CostData = memory_data.cost
		if cost.can_afford():
			GameData.spend_currency(cost)
			GameData.unlock_memory(sticker_name) ## this adds scenes to scenemanager
			unlocked = true
			update_cost_label()
			SceneManager.next_scene()
		else:
			DebugLog.dbg_from(self, "Not enough currency to unlock this memory.")


func update_cost_label() -> void:
	texture_button.texture_normal = load(memory_data.sticker_sprite_path)
	if unlocked:
		cost_label.text = ""
		texture_button.modulate = Color(1, 1, 1, 1) # make it look unlocked
	else:
		texture_button.modulate = Color(1, 1, 1, 0.25) # make it look locked
		var cost_text : String = str(memory_data.cost.get_cost(GameConstants.SMALL_FRAGMENTS))
		cost_label.text = cost_text
