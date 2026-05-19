extends CanvasLayer

@export var game_scene := SceneManager.SceneEnum.GAME
@export var game_button : BaseButton
@export var difficulty_label: RichTextLabel
@export var mouse_hub_button : BaseButton

func _ready() -> void:
	game_button.pressed.connect(on_game_button_pressed)
	mouse_hub_button.pressed.connect(on_mouse_hub_button_pressed)
	game_button.grab_focus() #select when game starts
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

func on_game_button_pressed() -> void:
	SceneManager.clear_game()
	SceneManager.switch_to(game_scene)
	print("clicked")

func on_mouse_hub_button_pressed() -> void:
	SceneManager.switch_to(SceneManager.SceneEnum.MOUSE_HUB)
