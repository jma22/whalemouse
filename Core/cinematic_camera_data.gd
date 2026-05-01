class_name CinematicCameraData
extends CameraData

@export var boss_focus: float = 0.6


func compute_follow_subject(ctx: CameraContext) -> Vector3:
	if ctx.cinematic_target == null or not is_instance_valid(ctx.cinematic_target):
		return ctx.player.global_position
	return ctx.player.global_position.lerp(ctx.cinematic_target.global_position, boss_focus)
