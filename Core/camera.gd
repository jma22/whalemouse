extends Camera3D

@export var target : Node3D = null
@export var distance : float = 1.2

@export var smooth_speed : float = 5.0

@export var lr_margin : float
@export var b_margin : float 
@export var t_margin : float
var bounds : AABB
# var offset : Vector3 = Vector3(0, 2, 2)



func get_offset() -> Vector3:
	var tilt : float = get_rotation().x * -1.0
	var offset_y : float = distance * sin(tilt)
	var offset_z : float = distance * cos(tilt)
	var offset = Vector3(0, offset_y, offset_z)
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



func get_camera_world_size(distance_from_camera: float) -> Vector2:
	# Get the viewport size (in pixels)
	var viewport_rect = get_viewport().get_visible_rect()
	var aspect = viewport_rect.size.x / viewport_rect.size.y
	
	# For Perspective Cameras
	# if projection == PROJECTION_PERSPECTIVE:
	var fov_rad = deg_to_rad(fov)
	var height = 2 * tan(fov_rad / 2) * distance_from_camera
	var width = height * aspect
	
	return Vector2(width, height)

func clamp_camera() -> void:
	if bounds == null:
		return
	var camera_world_size = get_camera_world_size(global_position.y*1.5)
	var min_x = bounds.position.x + camera_world_size.x / 2 - lr_margin
	var max_x = bounds.position.x + bounds.size.x - camera_world_size.x / 2 + lr_margin
	var min_z = bounds.position.z + camera_world_size.y / 2 - t_margin
	var max_z = bounds.position.z + bounds.size.z - camera_world_size.y / 2 + b_margin
	
	global_position.x = clamp(global_position.x, min_x, max_x)
	global_position.z = clamp(global_position.z, min_z, max_z)
