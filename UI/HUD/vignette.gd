extends ColorRect

@export var flash_duration : float = 0.6          ## seconds for the flash to fade out
# ---- Status settings ----
@export var status_fade_in  : float = 0.3
@export var status_fade_out : float = 0.5
 
var _flash_tween  : Tween
var _status_tween : Tween

var status_effect_manager : StatusEffectManager
var old_status_effects : Array[StatusEffect] = []
 
func setup(status_effect_manager_ : StatusEffectManager) -> void:
	status_effect_manager = status_effect_manager_
	
func _ready() -> void:
	# Make sure it starts invisible
	material.set_shader_parameter("flash_intensity", 0.0)
	material.set_shader_parameter("status_intensity", 0.0)
	mouse_filter = Control.MOUSE_FILTER_IGNORE   # don't eat clicks

func _process(_delta: float) -> void:
	if status_effect_manager:
		update_status(status_effect_manager.get_deduped_list())


## Call this to flash the vignette.  Optionally pass a custom color.
func flash_hurt() -> void:
	print("flashing")
	if _flash_tween and _flash_tween.is_running():
		_flash_tween.kill()
 
	material.set_shader_parameter("flash_intensity", 1.0)
	_flash_tween = create_tween()
	_flash_tween.tween_property(material, "shader_parameter/flash_intensity", 0.0, flash_duration)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func update_status(status_effects : Array[StatusEffect]) -> void:
	print("updating status effects: ", status_effects)
	if status_effects.size() != old_status_effects.size():
		if status_effect_manager.has_status_effect("slow"):
			set_status()
		else:
			clear_status()

	old_status_effects = status_effects.duplicate()


func set_status() -> void: 
	print("cold vignette")
	if _status_tween and _status_tween.is_running():
		_status_tween.kill()
 
	_status_tween = create_tween()
	_status_tween.tween_property(material, "shader_parameter/status_intensity", 1.0, status_fade_in)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
 
 
## Fade the status vignette away.
func clear_status() -> void:
	print("clearing vignette")
	if _status_tween and _status_tween.is_running():
		_status_tween.kill()
 
	_status_tween = create_tween()
	_status_tween.tween_property(material, "shader_parameter/status_intensity", 0.0, status_fade_out)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)