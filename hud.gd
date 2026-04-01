extends CanvasLayer
class_name HUD

@export var hp_display: HPDisplay
@export var blessing_bar: BlessingBar


func setup(player : Node3D) -> void:
	hp_display.setup(player)
	blessing_bar.sync_bar()

