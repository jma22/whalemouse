extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(on_clicked)


func on_clicked() -> void:
	SceneManager.reset_game()
	SceneManager.switch_to(SceneManager.SceneEnum.GAME)