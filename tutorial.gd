extends CanvasLayer

class_name Tutorial

@export var text_label : RichTextLabel
@export var container : Control
@export var texture : TextureRect
@export var background : ColorRect

var tween : Tween = null
var blessing_background : Texture2D = load("res://UI/BlessingBackground.png")
var curse_background : Texture2D = load("res://UI/CurseBackground.png")

@export var blessing_color : Color = Color(0.8, 0.8, 1.0, 1.0)
@export var curse_color : Color = Color(1.0, 0.8, 0.8, 1.0)

var displaying_tutorial : bool = false
var debounce_spam_timer : float = 0.3
var debounce_timer : float = 0.0
var tutorial_texts : Array = []

func _ready() -> void:
	container.modulate.a = 0.0
	background.modulate.a = 0.0
	visible = false
	TutorialManager.setup(self)

func _process(delta: float) -> void:
	if displaying_tutorial and Input.is_action_just_pressed("ui_accept") and debounce_timer <= 0.0:
		if tutorial_texts.size() > 0:
			var line = tutorial_texts.pop_front()
			show_text(line[0], line[1])
		else:
			exit_tutorial()
		debounce_timer = debounce_spam_timer
	if debounce_timer > 0.0:
		debounce_timer -= delta
func take_tutorial(tutorial_lines : Array) -> void:
	debounce_timer = debounce_spam_timer
	tutorial_texts = tutorial_lines
	if tutorial_texts.size() > 0:
		var line = tutorial_texts.pop_front()
		fade_in()
		show_text(line[0], line[1])

func fade_in() -> void:
	if tween and tween.is_valid():
		tween.kill()
	visible = true

	
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(container, "modulate:a", 1.0, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(background, "modulate:a", 0.8, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	displaying_tutorial = true
	SceneManager.pause_game()


func show_text(text : String, is_blessing : bool) -> void:
	if is_blessing:
		texture.texture = blessing_background
		text_label.add_theme_color_override("font_color", blessing_color)
		text_label.text = "[shake rate=4.0 level=4 connected=1]"
	else:
		texture.texture = curse_background
		text_label.add_theme_color_override("font_color", curse_color)
		text_label.text = "[shake rate=10.0 level=6 connected=1]"
	text_label.text += text
	text_label.text += "[/shake]"

# func display_tutorial(tutorial : String, is_blessing : bool) -> void:
# 	if tween and tween.is_valid():
# 		tween.kill()
# 	visible = true

# 	if is_blessing:
# 		texture.texture = blessing_background
# 		text_label.add_theme_color_override("font_color", blessing_color)
# 		text_label.text = "[shake rate=4.0 level=4 connected=1]"
# 	else:
# 		texture.texture = curse_background
# 		text_label.add_theme_color_override("font_color", curse_color)
# 		text_label.text = "[shake rate=10.0 level=6 connected=1]"
# 	text_label.text += tutorial
# 	text_label.text += "[/shake]"
# 	tween = create_tween()
# 	tween.set_parallel(true)
# 	tween.tween_property(container, "modulate:a", 1.0, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
# 	tween.tween_property(background, "modulate:a", 0.8, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
# 	displaying_tutorial = true
# 	await tween.finished
# 	SceneManager.pause_game()

func exit_tutorial() -> void:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(background, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(container, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	displaying_tutorial = false
	await tween.finished
	visible = false
	SceneManager.resume_game()
