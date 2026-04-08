extends CanvasLayer

class_name BlessingText

@export var text_label : RichTextLabel
@export var container : Control
@export var texture : TextureRect

var tween : Tween = null
var blessing_background : Texture2D = load("res://UI/Textbox/BlessingBackground.png")
var curse_background : Texture2D = load("res://UI/Textbox/CurseBackground.png")

@export var blessing_color : Color = Color(0.8, 0.8, 1.0, 1.0)
@export var curse_color : Color = Color(1.0, 0.8, 0.8, 1.0)

func _ready() -> void:
	container.modulate.a = 0.0

func display_blessing_info(blessing : String) -> void:
	if tween and tween.is_valid():
		tween.kill()
	# text_label.text = "Blessing: " + blessing
	
	if GlobalStats.is_blessing(blessing):
		texture.texture = blessing_background
		text_label.add_theme_color_override("font_color", blessing_color)
		text_label.text = "[shake rate=4.0 level=4 connected=1]"
	else:
		texture.texture = curse_background
		text_label.add_theme_color_override("font_color", curse_color)
		text_label.text = "[shake rate=10.0 level=6 connected=1]"
	text_label.text += GlobalStats.get_description(blessing)
	text_label.text += "[/shake]"
	tween = create_tween()
	tween.tween_property(container, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)

func exit_blessing_info() -> void:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.tween_property(container, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	
