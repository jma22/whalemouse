extends CanvasLayer

class_name BlessingText

@export var text_label : RichTextLabel
@export var container : Control

var tween : Tween = null

func _ready() -> void:
	container.modulate.a = 0.0

func display_blessing_info(blessing : String) -> void:
	if tween and tween.is_valid():
		tween.kill()
	text_label.text = "Blessing: " + blessing
	text_label.text += "\n" + GlobalStats.get_description(blessing)
	tween = create_tween()
	tween.tween_property(container, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)

func exit_blessing_info() -> void:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.tween_property(container, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	
