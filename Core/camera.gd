extends Camera3D

@export var target : Node3D = null
@export var wave_distance : float = 1.9
@export var boss_distance : float = 2.5

@export var smooth_speed : float = 5.0

@export var lr_margin : float
@export var b_margin : float
@export var t_margin : float

@export_group("Shake")
@export var shake_strength : float = 0.15
@export var shake_duration : float = 0.2
@export var shake_noise_frequency : float = 50.0
@export var shake_noise_speed : float = 4.0

var bounds : AABB
# var offset : Vector3 = Vector3(0, 2, 2)
var distance :float = 1.9

@export var _shake_time_left : float = 0.0
var _shake_time_total : float = 0.0
var _shake_noise : FastNoiseLite = FastNoiseLite.new()
var _shake_elapsed : float = 0.0


func _ready() -> void:
	_shake_noise.frequency = shake_noise_frequency
	_shake_noise.seed = randi()

func set_wave_mode() -> void:
	distance = wave_distance

func set_boss_mode() -> void:
	distance = boss_distance

func get_offset() -> Vector3:
	var tilt : float = get_rotation().x * -1.0
	var offset_y : float = distance * sin(tilt)
	var offset_z : float = distance * cos(tilt)
	var offset : Vector3= Vector3(0, offset_y, offset_z)
	# offset = offset.rotated(Vector3(1, 0, 0), get_rotation().x)
	# print("Offset after rotation: ", offset)
	return offset

func set_bounds(bounds : AABB) -> void:
	self.bounds = bounds

func _process(delta: float) -> void:
	if target == null:
		return
	var desired_position : Vector3 = target.global_position + get_offset()
	desired_position.y = get_offset().y
	global_position = global_position.lerp(desired_position, smooth_speed * delta)
	# clamp_camera()
	_apply_shake(delta)



func get_camera_world_size(distance_from_camera: float) -> Vector2:
	# Get the viewport size (in pixels)
	var viewport_rect : Rect2 = get_viewport().get_visible_rect()
	var aspect : float = viewport_rect.size.x / viewport_rect.size.y
	
	# For Perspective Cameras
	# if projection == PROJECTION_PERSPECTIVE:
	var fov_rad : float = deg_to_rad(fov)
	var height : float = 2 * tan(fov_rad / 2) * distance_from_camera
	var width : float = height * aspect
	
	return Vector2(width, height)

func clamp_camera() -> void:
	if bounds == null:
		return
	var camera_world_size : Vector2 = get_camera_world_size(global_position.y*1.5)
	var min_x : float = bounds.position.x + camera_world_size.x / 2 - lr_margin
	var max_x : float = bounds.position.x + bounds.size.x - camera_world_size.x / 2 + lr_margin
	var min_z : float = bounds.position.z + camera_world_size.y / 2 - t_margin
	var max_z : float = bounds.position.z + bounds.size.z - camera_world_size.y / 2 + b_margin
	
	global_position.x = clamp(global_position.x, min_x, max_x)
	global_position.z = clamp(global_position.z, min_z, max_z)

func camera_shake(strength : float = -1.0, duration : float = -1.0) -> void:
	var s : float = strength if strength > 0.0 else shake_strength
	var d : float = duration if duration > 0.0 else shake_duration
	_shake_time_left = max(_shake_time_left, d)
	_shake_time_total = max(_shake_time_total, d)
	shake_strength = s

func _apply_shake(delta: float) -> void:
	if _shake_time_left <= 0.0:
		return
	_shake_time_left -= delta
	_shake_elapsed += delta
	var decay : float = clamp(_shake_time_left / _shake_time_total, 0.0, 1.0)
	var amount : float = shake_strength * decay * decay
	var t : float = _shake_elapsed * shake_noise_speed
	var ox : float = _shake_noise.get_noise_2d(t, 0.0) * amount
	var oy : float = _shake_noise.get_noise_2d(0.0, t) * amount
	var oz : float = _shake_noise.get_noise_2d(t, t) * amount
	global_position += Vector3(ox, oy, oz)
	if _shake_time_left <= 0.0:
		_shake_elapsed = 0.0
		_shake_time_total = 0.0
