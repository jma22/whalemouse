extends Control

class_name BossHealth

@export var health_bar : TextureProgressBar
@export var boss_name : RichTextLabel

var tween : Tween

func setup(boss_name_ : String, max_health : int) -> void:
	boss_name.text = boss_name_
	health_bar.max_value = max_health
	health_bar.value = max_health
	self.visible = true

# func hide() -> void:
# 	self.visible = false

func update_health(current_health : int) -> void:
	health_bar.value = current_health

func flash_health_bar() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_callback(set_flash)
	tween.tween_property(health_bar, "tint_progress", Color(1, 1, 1), 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)


func set_flash() -> void:
	health_bar.tint_progress = Color(3,3,3)
