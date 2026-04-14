extends CanvasLayer
class_name HUD

@export var hp_display: HPDisplay
@export var blessing_bar: BlessingBar
@export var time_damage_manager: TimeDamageManager
@export var whale_spawner: WhaleSpawner
@export var boss_health: BossHealth
@export var vignette: ColorRect

func setup(player : Node3D) -> void:
	hp_display.setup(player, time_damage_manager, whale_spawner)
	vignette.setup(player.status_effect_manager)
	blessing_bar.sync_bar()
	boss_health.hide()

	
func flash_hurt_vignette() -> void:
	vignette.flash_hurt()

func set_vignette_status() -> void:
	vignette.set_status()

func clear_vignette_status() -> void:
	vignette.clear_status()