
extends Button

@export var text_label : RichTextLabel
# Called when the node enters the scene tree for the first time.
var tween : Tween = null
func _ready() -> void:
	pressed.connect(on_clicked)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func on_clicked() -> void:
	SceneManager.reset_game()
	SceneManager.switch_to(SceneManager.SceneEnum.GAME)

func _on_mouse_entered() -> void:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.tween_property(self,"scale", Vector2(1.1, 1.1), 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.play()
	text_label.text = "[u]"
	text_label.text += "[shake rate=6.0 level=6 connected=1]Start[/shake]"
	text_label.text += "[/u]"

func _on_mouse_exited() -> void:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.tween_property(self,"scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.play()
	text_label.text = "[shake rate=4.0 level=4 connected=1]Start[/shake]"
