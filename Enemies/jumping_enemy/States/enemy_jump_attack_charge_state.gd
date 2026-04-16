extends EnemyChargeStateBase

class_name EnemyJumpAttackChargeState


func choose_target() -> Vector3:
	var angle : float = randf() * 2.0 * PI
	var radius : float = randf_range(1.8, 2.3)
	var offset : Vector3 = Vector3(cos(angle), 0, sin(angle)) * radius
	var target_point : Vector3 = entity.global_transform.origin + offset
	# print("vector jump", vec)

	if not entity.get_floor().check_in_bounds(target_point):
		target_point = entity.get_floor().mirror_position(target_point)
	return target_point
