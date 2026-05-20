extends CanvasLayer
class_name WaveText

@export var background : ColorRect
@export var text_label : RichTextLabel
@export var wave_icon : TextureRect
@export var container : Control

@export_group("Wave Icons")
@export var combat_icon : Texture
@export var shrine_icon : Texture
@export var boss_icon : Texture
var tween : Tween = null

func _ready() -> void:
	container.modulate.a = 0.0


func display_wave_info(wave_info : WaveInfo) -> void:
	# Kill previous tween
	if tween and tween.is_valid():
		tween.kill()

	# Reset alpha immediately
	container.modulate.a = 0.0

	# Set Wave Icon
	match wave_info.room_type:
		WaveInfo.WaveType.Combat:
			wave_icon.texture = combat_icon
		WaveInfo.WaveType.Shrine:
			wave_icon.texture = shrine_icon
		WaveInfo.WaveType.Boss:
			wave_icon.texture = boss_icon

	# Set text
	text_label.clear()
	text_label.text = "[shake rate=4.0 level=4 connected=1]"
	text_label.text += wave_info.name
	text_label.text += "[/shake]"

	tween = create_tween()
	tween.tween_property(container, "modulate:a", 1.0, 0.5)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_IN)

	tween.tween_interval(0.5)

	tween.tween_property(container, "modulate:a", 0.0, 1.5)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_OUT)
