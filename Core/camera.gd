extends Camera3D

@export var target : Node3D = null
@export var wave_distance : float = 1.9
@export var boss_distance : float = 2.5

@export var smooth_speed : float = 5.0
@export var blend_speed: float = 3.0


# Battle framing
var current_blend: float = 0.0          # current
var current_blend_target: float = 0.0   # where we're heading
var in_combat: bool = false

@export var explore_blend: float = 0.0   # 0 = pure follow
@export var combat_blend: float = 0.6    # bias toward arena center


@export var lr_margin : float
@export var b_margin : float
@export var t_margin : float

@export_group("Shake")
@export var shake_strength : float = 0.15
@export var shake_duration : float = 0.2
@export var shake_noise_frequency : float = 50.0
@export var shake_noise_speed : float = 4.0

@export_group("Cinematic")
@export var cinematic_blend_speed: float = 2.0
@export var cinematic_wander_amount: float = 0.35  # how far the camera drifts (m)
@export var cinematic_wander_freq: float = 0.4     # wander tempo

var map : NavigationRegion3D
# var offset : Vector3 = Vector3(0, 2, 2)
var distance :float = 1.9

@export var _shake_time_left : float = 0.0
var _shake_time_total : float = 0.0
var _shake_noise : FastNoiseLite = FastNoiseLite.new()
var _shake_elapsed : float = 0.0

# Cinematic state
var cinematic_target: Node3D = null
var cinematic_active: bool = false
var _cinematic_blend: float = 0.0
var _cinematic_time: float = 0.0
var _wander_noise: FastNoiseLite = FastNoiseLite.new()


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

func set_map(floor: NavigationRegion3D) -> void:
	self.map = floor

func set_combat(active: bool) -> void:
	in_combat = active
	current_blend_target = combat_blend if active else explore_blend

func _process(delta: float) -> void:
	if target == null:
		return

	var t : float = 1.0 - exp(-blend_speed * delta)
	current_blend = lerp(current_blend, current_blend_target, t)
	## AI
	# # --- cinematic blend ---
	var cine_goal: float = 1.0 if cinematic_active else 0.0
	var cine_t: float = 1.0 - exp(-cinematic_blend_speed * delta)
	_cinematic_blend = lerp(_cinematic_blend, cine_goal, cine_t)
 
	# keep wander clock running while blending so motion stays smooth
	if cinematic_active or _cinematic_blend > 0.001:
		_cinematic_time += delta
 
	# --- pick what we're following ---
	var follow_subject: Vector3 = target.global_position
	if _cinematic_blend > 0.001 and cinematic_target != null and is_instance_valid(cinematic_target):
		DebugLog.dbg_from(self, "Cinematic active. Blending to boss at position: " + str(cinematic_target.global_position))
		follow_subject = target.global_position.lerp(cinematic_target.global_position, _cinematic_blend)

	## AI
	var arena_center : Vector3 = map.global_position
	# var follow_point : Vector3 = target.global_position.lerp(arena_center, current_blend)
	var follow_point : Vector3 = follow_subject.lerp(arena_center, current_blend)

	var desired_position : Vector3 = follow_point + get_offset()
	desired_position.y = get_offset().y

	DebugLog.dbg_from(self, "Shake amount:" + str(_compute_wander()))
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

# func clamp_camera() -> void:
# 	if bounds == null:
# 		return
# 	var camera_world_size : Vector2 = get_camera_world_size(global_position.y*1.5)
# 	var min_x : float = bounds.position.x + camera_world_size.x / 2 - lr_margin
# 	var max_x : float = bounds.position.x + bounds.size.x - camera_world_size.x / 2 + lr_margin
# 	var min_z : float = bounds.position.z + camera_world_size.y / 2 - t_margin
# 	var max_z : float = bounds.position.z + bounds.size.z - camera_world_size.y / 2 + b_margin
	
# 	global_position.x = clamp(global_position.x, min_x, max_x)
# 	global_position.z = clamp(global_position.z, min_z, max_z)

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

func _compute_wander() -> Vector3:
	var wt: float = _cinematic_time * cinematic_wander_freq
	var wx: float = _wander_noise.get_noise_2d(wt + 13.0, 7.0)
	var wy: float = _wander_noise.get_noise_2d(wt + 41.0, 23.0)
	var wz: float = _wander_noise.get_noise_2d(wt + 71.0, 53.0)
	return Vector3(wx, wy * 0.4, wz) * cinematic_wander_amount

func start_cinematic(boss: Node3D) -> void:
	if boss == null:
		return
	cinematic_target = boss
	cinematic_active = true
	_cinematic_time = 0.0
 
func end_cinematic() -> void:
	cinematic_active = false