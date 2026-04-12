extends Control

class_name BossHealth

@export var health_bar : TextureProgressBar
@export var boss_name : RichTextLabel

func setup(boss_name_ : String, max_health : int) -> void:
	boss_name.text = boss_name_
	health_bar.max_value = max_health
	health_bar.value = max_health
	self.visible = true

# func hide() -> void:
# 	self.visible = false

func update_health(current_health : int) -> void:
	health_bar.value = current_health