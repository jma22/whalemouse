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

func _process(_delta: float) -> void:
	if not SceneManager.can_pause():
		return
	if Input.is_action_just_pressed("pause"):
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
	SceneManager.set_paused(true)
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
	TutorialManager.resume_tutorial()
	
	# Only unpauses character if not showing tutorial
	if not TutorialManager.is_tutorial_active():
		SceneManager.set_paused(false)
	is_paused = false
