extends CanvasLayer
class_name HUD

@export var hp_display: HPDisplay


func setup(player : Node3D) -> void:
	hp_display.setup(player)
