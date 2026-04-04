extends CanvasLayer

@export var text_label : RichTextLabel
@export var background : ColorRect
@export var container : Control

var tween : Tween = null
var is_paused : bool = false

func _ready() -> void:
	container.modulate.a = 0.0
	background.modulate.a = 0.0
	visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_close_dialog"):
		if is_paused:
			exit_tutorial()
		else:
			fade_in()
		


func fade_in() -> void:
	if tween and tween.is_valid():
		tween.kill()
	visible = true
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(container, "modulate:a", 1.0, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(background, "modulate:a", 0.8, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	SceneManager.pause_game()
	TutorialManager.pause_tutorial()
	is_paused = true




func exit_tutorial() -> void:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(background, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(container, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await tween.finished
	visible = false
	SceneManager.resume_game()
	TutorialManager.resume_tutorial()
	is_paused = false
