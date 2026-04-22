extends Node3D
class_name ShieldComponent

@export var shield_sprite : Sprite3D
@export var fade_duration : float = 0.2
@export var flash_color : Color = Color(2.0, 2.0, 2.0, 1.0)

var is_active : bool = false
var _tween : Tween


func setup(entity : Node3D) -> void:
	if shield_sprite:
		shield_sprite.visible = false
		shield_sprite.modulate = Color(1.0, 1.0, 1.0, 0.0)
	transform.origin = entity.sprite_manager.transform.origin
func activate_shield() -> void:
	is_active = true
	if shield_sprite:
		shield_sprite.visible = true
		_fade_to(1.0)


func lose_shield() -> void:
	if not is_active:
		return
	is_active = false
	if not shield_sprite:
		return
	if _tween and _tween.is_running():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_callback(func() -> void: shield_sprite.modulate = flash_color)
	_tween.tween_property(shield_sprite, "modulate:a", 0.0, fade_duration)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	_tween.finished.connect(func() -> void:
		shield_sprite.visible = false
		shield_sprite.modulate = Color(1.0, 1.0, 1.0, 0.0)
	)

func _fade_to(target_alpha: float, on_done: Callable = Callable()) -> void:
	if _tween and _tween.is_running():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(shield_sprite, "modulate:a", target_alpha, fade_duration)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	if on_done.is_valid():
		_tween.finished.connect(on_done)

