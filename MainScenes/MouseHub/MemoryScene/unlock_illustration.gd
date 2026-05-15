extends Control
class_name UnlockIllustration


# @export var texture_rect : TextureRect
@export var texture_button : TextureButton
@export var cost_label : RichTextLabel

var unlockable : MemoryUnlockable
var memory_scene : Control
var unlocked : bool = false


func setup(unlockable_ : MemoryUnlockable, memory_scene_ : Control) -> void:
	self.unlockable = unlockable_
	self.memory_scene = memory_scene_
	unlocked = GameData.is_illustration_unlocked(unlockable_)

	texture_button.pressed.connect(on_texture_button_pressed)
	update_cost_label()


func on_texture_button_pressed() -> void:
	if unlocked:
		return
	var cost : CostData = unlockable.cost
	if cost.can_afford():
		GameData.spend_currency(cost)
		GameData.unlock_unlockable(unlockable) ## this adds scenes to scenemanager
		unlocked = true
		update_cost_label()
		SceneManager.next_scene()
	else:
		DebugLog.dbg_from(self, "Not enough currency to unlock this illustration.")


func update_cost_label() -> void:
	texture_button.texture_normal = load(unlockable.illustration_path)
	if unlocked:
		cost_label.text = ""
		texture_button.modulate = Color(1, 1, 1, 1)
	else:
		texture_button.modulate = Color(1, 1, 1, 0.25)
		var cost_text : String = str(unlockable.cost.get_cost(GameConstants.SMALL_FRAGMENTS))
		cost_label.text = cost_text
