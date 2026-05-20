extends CanvasLayer

@export var game_scene := SceneManager.SceneEnum.GAME
@export var game_button : BaseButton
@export var difficulty_label: RichTextLabel

func _ready() -> void:
	game_button.grab_focus()
	update_difficulty_text()
	
func update_difficulty_text() -> void:
	var text := ""
	match Config.get_difficulty():
		Config.Difficulty.EASY:
			text = "Easy"
		Config.Difficulty.NORMAL:
			text = "Medium"
		Config.Difficulty.HARD:
			text = "Hard"
	
	difficulty_label.text = text

func _on_game_button_pressed() -> void:
	SceneManager.clear_game()
	SceneManager.switch_to(game_scene)
	print("clicked")

func _on_relics_button_pressed() -> void:
	$RelicsScreen.visible = true

func _on_book_button_pressed() -> void:
	$BookScreen.visible = true
