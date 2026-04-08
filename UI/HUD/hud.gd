extends CanvasLayer
class_name HUD

@export var hp_display: HPDisplay
@export var blessing_bar: BlessingBar
@export var time_damage_manager: TimeDamageManager
@export var whale_spawner: WhaleSpawner


func setup(player : Node3D) -> void:
	hp_display.setup(player, time_damage_manager, whale_spawner)
	blessing_bar.sync_bar()
