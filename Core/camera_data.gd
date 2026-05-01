class_name CameraData
extends Resource

@export var distance: float = 1.9
@export var fov: float = 75.0
@export var arena_blend: float = 0.0
@export var smooth_speed: float = 5.0

@export_group("FOV Boost")
@export var fov_z_boost: float = 0.0
@export var fov_z_range: float = 5.0

@export_group("Wander")
@export var wander_amount: float = 0.0
@export var wander_freq: float = 0.4

var _wander_noise: FastNoiseLite


func compute_desired_position(ctx: CameraContext) -> Vector3:
	var subject: Vector3 = compute_follow_subject(ctx)
	var follow_point: Vector3 = subject.lerp(ctx.arena_center, arena_blend)
	var offset: Vector3 = _get_offset(ctx.camera_pitch)
	var pos: Vector3 = follow_point + offset
	pos.y = offset.y
	pos += _compute_wander(ctx.time)
	return pos


func compute_fov(ctx: CameraContext) -> float:
	if fov_z_boost <= 0.0:
		return fov
	var z_delta: float = ctx.player.global_position.z - ctx.arena_center.z
	var t: float = clamp(z_delta / fov_z_range, 0.0, 1.0)
	return fov + fov_z_boost * t


func compute_follow_subject(ctx: CameraContext) -> Vector3:
	return ctx.player.global_position


func _get_offset(pitch: float) -> Vector3:
	var tilt: float = -pitch
	return Vector3(0.0, distance * sin(tilt), distance * cos(tilt))


func _compute_wander(t: float) -> Vector3:
	if wander_amount <= 0.0:
		return Vector3.ZERO
	if _wander_noise == null:
		_wander_noise = FastNoiseLite.new()
		_wander_noise.seed = randi()
	var wt: float = t * wander_freq
	var wx: float = _wander_noise.get_noise_2d(wt + 13.0, 7.0)
	var wy: float = _wander_noise.get_noise_2d(wt + 41.0, 23.0) * 0.4
	var wz: float = _wander_noise.get_noise_2d(wt + 71.0, 53.0)
	return Vector3(wx, wy, wz) * wander_amount
