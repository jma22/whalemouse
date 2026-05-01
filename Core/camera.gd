extends Camera3D

@export var target: Node3D
@export var map: NavigationRegion3D

@export_group("Modes")
@export var default_data: CameraData
@export var combat_data: CameraData
@export var boss_data: CameraData
@export var cinematic_data: CameraData
@export var current_data: CameraData

@export_group("Blending")
@export var mode_blend_speed: float = 3.0

@export_group("Shake")
@export var shake_strength: float = 0.15
@export var shake_duration: float = 0.2
@export var shake_noise_frequency: float = 50.0
@export var shake_noise_speed: float = 4.0

var _previous_data: CameraData
var _pre_cinematic_data: CameraData
var _blend: float = 1.0
var _time: float = 0.0
var _boss_mode: bool = false
var _cinematic_target: Node3D

var _shake_time_left: float = 0.0
var _shake_time_total: float = 0.0
var _shake_elapsed: float = 0.0
var _shake_noise: FastNoiseLite = FastNoiseLite.new()


func _ready() -> void:
	_shake_noise.frequency = shake_noise_frequency
	_shake_noise.seed = randi()
	if current_data == null:
		current_data = default_data


func set_map(floor: NavigationRegion3D) -> void:
	map = floor

func set_wave_mode() -> void:
	_boss_mode = false
	switch_mode(default_data)

func set_boss_mode() -> void:
	_boss_mode = true

func set_combat(active: bool) -> void:
	if active:
		switch_mode(boss_data if _boss_mode else combat_data)
	else:
		switch_mode(default_data)

func start_cinematic(boss: Node3D) -> void:
	if boss == null:
		return
	_cinematic_target = boss
	_pre_cinematic_data = current_data
	switch_mode(cinematic_data)

func end_cinematic() -> void:
	_cinematic_target = null
	switch_mode(_pre_cinematic_data if _pre_cinematic_data != null else default_data)
	_pre_cinematic_data = null

func switch_mode(new_data: CameraData) -> void:
	if new_data == null or new_data == current_data:
		return
	_previous_data = current_data
	current_data = new_data
	_blend = 0.0


func _process(delta: float) -> void:
	if target == null or current_data == null:
		return
	_time += delta

	var ctx : CameraContext = CameraContext.new()
	ctx.player = target
	ctx.arena_center = map.global_position if map != null else Vector3.ZERO
	ctx.camera_pitch = rotation.x
	ctx.cinematic_target = _cinematic_target
	ctx.time = _time

	_blend = min(1.0, _blend + mode_blend_speed * delta)

	var desired_position: Vector3
	var desired_fov: float
	var smooth: float

	if _previous_data != null and _blend < 1.0:
		var pos_a: Vector3 = _previous_data.compute_desired_position(ctx)
		var pos_b: Vector3 = current_data.compute_desired_position(ctx)
		desired_position = pos_a.lerp(pos_b, _blend)
		desired_fov = lerp(_previous_data.compute_fov(ctx), current_data.compute_fov(ctx), _blend)
		smooth = lerp(_previous_data.smooth_speed, current_data.smooth_speed, _blend)
	else:
		desired_position = current_data.compute_desired_position(ctx)
		desired_fov = current_data.compute_fov(ctx)
		smooth = current_data.smooth_speed
		_previous_data = null

	var t: float = 1.0 - exp(-smooth * delta)
	global_position = global_position.lerp(desired_position, t)
	fov = lerp(fov, desired_fov, t)

	_apply_shake(delta)


func camera_shake(strength: float = -1.0, duration: float = -1.0) -> void:
	var s: float = strength if strength > 0.0 else shake_strength
	var d: float = duration if duration > 0.0 else shake_duration
	_shake_time_left = max(_shake_time_left, d)
	_shake_time_total = max(_shake_time_total, d)
	shake_strength = s

func _apply_shake(delta: float) -> void:
	if _shake_time_left <= 0.0:
		return
	_shake_time_left -= delta
	_shake_elapsed += delta
	var decay: float = clamp(_shake_time_left / _shake_time_total, 0.0, 1.0)
	var amount: float = shake_strength * decay * decay
	var t: float = _shake_elapsed * shake_noise_speed
	var ox: float = _shake_noise.get_noise_2d(t, 0.0) * amount
	var oy: float = _shake_noise.get_noise_2d(0.0, t) * amount
	var oz: float = _shake_noise.get_noise_2d(t, t) * amount
	global_position += Vector3(ox, oy, oz)
	if _shake_time_left <= 0.0:
		_shake_elapsed = 0.0
		_shake_time_total = 0.0


func get_camera_world_size(distance_from_camera: float) -> Vector2:
	var viewport_rect: Rect2 = get_viewport().get_visible_rect()
	var aspect: float = viewport_rect.size.x / viewport_rect.size.y
	var fov_rad: float = deg_to_rad(fov)
	var height: float = 2 * tan(fov_rad / 2) * distance_from_camera
	var width: float = height * aspect
	return Vector2(width, height)
