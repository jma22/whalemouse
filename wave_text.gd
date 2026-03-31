extends CanvasLayer

class_name WaveText

@export var text_label : RichTextLabel
@export var container : Control

func _ready() -> void:
	container.modulate.a = 0.0
func display_wave_info(wave_info : WaveInfo) -> void:
	text_label.text = "Wave " + str(wave_info.wave_number)
	var tween : Tween = create_tween()
	tween.tween_property(container, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.tween_interval(0.5)
	tween.tween_property(container, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.play()
