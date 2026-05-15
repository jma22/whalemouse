extends Node3D

@export var game_button : Button
@export var mouse_hub_button : Button

func setup() -> void:
	game_button.pressed.connect(on_game_button_pressed)
	mouse_hub_button.pressed.connect(on_mouse_hub_button_pressed)
	game_button.grab_focus() #select when game starts

func on_game_button_pressed() -> void:
	SceneManager.clear_game()
	SceneManager.switch_to(SceneManager.SceneEnum.GAME)

func on_mouse_hub_button_pressed() -> void:
	SceneManager.switch_to(SceneManager.SceneEnum.MOUSE_HUB)
