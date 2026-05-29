extends CanvasLayer
class_name HUD

@export var hp_display: HPDisplay
@export var blessing_bar: BlessingBar
@export var time_damage_manager: TimeDamageManager
# @export var whale_spawner: WhaleSpawner
@export var boss_health: BossHealth
@export var vignette: ColorRect
@export var boss_info: BossInfoBar
@export var letter_box: LetterBox
@export var boss_name : RichTextLabel

func setup(player : Node3D) -> void:
	hp_display.setup(player, time_damage_manager)
	vignette.setup(player.status_effect_manager)
	blessing_bar.sync_bar()
	boss_info.sync_bar()
	boss_health.hide()
	boss_name.hide()

	
func reset() -> void:
	blessing_bar.sync_bar()
	boss_info.sync_bar()
	boss_health.hide()
	vignette.clear_status()



func flash_hurt_vignette() -> void:
	vignette.flash_hurt()

func set_vignette_status() -> void:
	vignette.set_status()

func clear_vignette_status() -> void:
	vignette.clear_status()

func show_boss_intro_hud(boss_name_str: String) -> void:
	boss_name.text = boss_name_str
	hp_display.hide()
	vignette.hide()
	blessing_bar.hide()
	boss_health.hide()
	letter_box.show_letter_box()
	await letter_box.tween.finished
	boss_name.fade_in()

func hide_boss_intro_hud() -> void:
	boss_name.fade_out()
	letter_box.hide_letter_box()
	await letter_box.tween.finished
	hp_display.show()
	vignette.show()
	blessing_bar.show()
	boss_health.show()	
