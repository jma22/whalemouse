extends CanvasLayer
class_name BlessingText

@export var item_name_text: RichTextLabel
@export var item_description_text: RichTextLabel
@export var container: Control
@export var texture: TextureRect

@export var blessing_color: Color = Color(0.8, 0.8, 1.0, 1.0)
@export var curse_color: Color = Color(1.0, 0.8, 0.8, 1.0)

var tween: Tween

var blessing_background: Texture2D = preload("res://UI/Textbox/BlessingBackground.png")
var curse_background: Texture2D = preload("res://UI/Textbox/CurseBackground.png")

func _ready() -> void:
	container.modulate.a = 0.0


func display_blessing_info(upgrade: Choice) -> void:
	_kill_tween()

	_setup_visuals(upgrade)
	_fade(1.0, Tween.EASE_IN)


func exit_blessing_info() -> void:
	_kill_tween()
	_fade(0.0, Tween.EASE_OUT)


# ------------------------
# Internal helpers
# ------------------------

func _setup_visuals(upgrade: Choice) -> void:
	var is_blessing : bool = upgrade.is_blessing()
	texture.texture = blessing_background if is_blessing else curse_background
	var color : Color = blessing_color if is_blessing else curse_color
	item_description_text.add_theme_color_override("font_color", color)
	
	# Name
	item_name_text.text = upgrade.display_name

	# Description with shake effect
	var shake_tag := "[shake rate=4.0 level=4 connected=1]" if is_blessing else "[shake rate=10.0 level=6 connected=1]"
	
	item_description_text.text = (
		shake_tag +
		upgrade.get_description() +
		"[/shake]"
	)


func _fade(target_alpha: float, ease_type: Tween.EaseType) -> void:
	tween = create_tween()
	tween.tween_property(container, "modulate:a", target_alpha, 0.5) \
		.set_trans(Tween.TRANS_LINEAR) \
		.set_ease(ease_type)


func _kill_tween() -> void:
	if tween and tween.is_valid():
		tween.kill()
