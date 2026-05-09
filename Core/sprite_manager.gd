extends Sprite3D

class_name SpriteManager

@export var frames_per_second : float = 4
@export var layer_number : int = 1
var hitstop : HitStop
var current_idx : int = 0
var time_accumulator : float = 0.0
var looping : bool = true
var current_animation : AnimationClip = null
var is_done : bool = false
var tween : Tween = null
@export var not_tilted : bool = false

func _ready() -> void:
	if not not_tilted:
		self.rotation_degrees = Vector3(Constants.TILT_ANGLE, 0, 0)
	await get_tree().process_frame
	

func _shader_has_uniform(shader: Shader, uniform_name: String) -> bool:
	for u : Dictionary in shader.get_shader_uniform_list():
		if u.name == uniform_name:
			return true
	return false

	
func setup(hitstop_: HitStop) -> void:
	hitstop = hitstop_
	## visual instance 3d layer
	set_layer_mask_value(layer_number, true)
	material_overlay.render_priority = render_priority + 1
	material_overlay.set_shader_parameter("texture_albedo", texture)
	var half_h : float = texture.get_height() * pixel_size / 2.0
	material_overlay.set_shader_parameter("mesh_bottom", -half_h)
	material_overlay.set_shader_parameter("mesh_top", half_h)
	material_overlay.set_shader_parameter("charge_level", 0)
	material_overlay.set_shader_parameter("flash_level", 0)

	if material_override:
		material_override.set_shader_parameter("texture_albedo", texture)
		# material_override.next_pass.set_shader_parameter("texture_albedo", texture)
	_configure_material_override()

func _configure_material_override() -> void:
	pass



func reset() -> void:
	current_idx = 0
	time_accumulator = 0.0
	current_animation = null
	looping = true
	modulate = Color(1, 1, 1, 1)

func _process(delta: float) -> void:

	if current_animation == null:
		return
	if hitstop and hitstop.is_in_hitstop:
		return
	
	time_accumulator += delta
	var frame_time : float = 1.0 / frames_per_second
	if time_accumulator >= frame_time:
		current_idx += 1
		if current_idx >= current_animation.frame_numbers.size():
			if looping:
				current_idx = 0
			else:
				current_idx = current_animation.frame_numbers.size() - 1
				current_animation = null
				is_done = true
		
		if current_animation != null:
			frame = min(hframes * vframes - 1, current_animation.frame_numbers[current_idx])
		time_accumulator = 0.0


func play(animation: AnimationClip, loop: bool = true) -> void:
	if animation == null or animation.is_empty():
		return
	is_done = false
	current_animation = animation
	current_idx = 0
	time_accumulator = 0.0
	looping = loop
	frame = min(hframes * vframes - 1, current_animation.frame_numbers[current_idx])

func check_is_done() -> bool:
	return is_done

func set_flip(is_left: bool) -> void:
	self.flip_h = is_left

func damage_flash() -> void:
	if tween != null and tween.is_valid():
		await tween.finished
	tween = get_tree().create_tween()
	#material_overlay.set_shader_parameter("flash_level)", 1)
	tween.tween_callback(Callable(self, "set_flash_level").bind(1))
	tween.tween_property(self,"material_overlay:shader_parameter/flash_level", 0, 0.2)
	tween.play()

func set_flash_level(level : float) -> void:
	material_overlay.set_shader_parameter("flash_level", level)
func set_charge_color(progress : float) -> void:
	material_overlay.set_shader_parameter("charge_level", progress)

func die() -> Tween:
	if tween != null and tween.is_valid():
		await tween.finished

	var death_tween : Tween = create_tween()
	death_tween.tween_callback(Callable(self, "set_flash_level").bind(0))
	death_tween.tween_callback(Callable(self, "set_charge_color").bind(0))
	death_tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.2)
	return death_tween
