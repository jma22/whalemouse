extends NavigationRegion3D
class_name FloorNav
@export var floor_material: MeshInstance3D

var material : ShaderMaterial
var player : CharacterBody3D
# var discrete_time : float = 0.01
var time_accumulator : float = 0.0

var offset : Vector2 = Vector2(0,0.2)
var size : Vector3
var global_margin : float = 0.5


func setup(player : CharacterBody3D, camera : Camera3D) -> void:
	material = floor_material.get_surface_override_material(0) as ShaderMaterial
	self.player = player
	size = floor_material.mesh.get_aabb().size
	## set size of the mesh in shader parameters
	material.set_shader_parameter("world_size", Vector2(size.x, size.z))
	material.set_shader_parameter("world_origin", Vector2(global_transform.origin.x, global_transform.origin.z) - Vector2(size.x / 2, size.z / 2))

func _process(delta: float) -> void:
	# time_accumulator += delta
	# if time_accumulator >= discrete_time:
	# 	time_accumulator -= discrete_time
	if not player:
		return
	var pos : Vector3 = player.global_position
	material.set_shader_parameter("world_center", Vector2(pos.x, pos.z) + offset)
	material.set_shader_parameter("shadow_center", Vector2(pos.x, pos.z) + offset/2)

# # In FloorNav
func clamp_body(body: CharacterBody3D, knockback : KnockbackComponent, bounce: float = 1.0) -> void:
	var min_b := global_transform.origin - size / 2 + Vector3(global_margin, 0, global_margin)
	var max_b := global_transform.origin + size / 2 - Vector3(global_margin, 0, global_margin)
	var pos := body.global_position
	var velocity_copy : Vector3 = body.velocity
	var flipped : bool = false
	if pos.x < min_b.x or pos.x > max_b.x:
		flipped = true
		velocity_copy.x *= -bounce - 1
	if pos.z < min_b.z or pos.z > max_b.z:
		flipped = true
		velocity_copy.z *= -bounce - 1
	if flipped:
		knockback.knockback_velocity += velocity_copy

	body.global_position.x = clampf(pos.x, min_b.x, max_b.x)
	body.global_position.z = clampf(pos.z, min_b.z, max_b.z)


# In FloorNav
# func bounce_body(body: CharacterBody3D, knockback: KnockbackComponent, bounce_force: float = 5.0) -> void:
# 	var min_b := global_transform.origin - size / 2
# 	var max_b := global_transform.origin + size / 2
# 	var pos := body.global_position
# 	var bounce_dir := Vector3.ZERO

# 	if pos.x < min_b.x:
# 		bounce_dir.x = 1.0
# 	elif pos.x > max_b.x:
# 		bounce_dir.x = -1.0

# 	if pos.z < min_b.z:
# 		bounce_dir.z = 1.0
# 	elif pos.z > max_b.z:
# 		bounce_dir.z = -1.0

# 	if bounce_dir != Vector3.ZERO:
# 		# Push knockback so it persists across frames
# 		knockback.knockback_velocity = bounce_dir.normalized() * bounce_force * knockback.knockback_mult
# 		# Clamp position back in bounds
# 		body.global_position.x = clampf(pos.x, min_b.x, max_b.x)
# 		body.global_position.z = clampf(pos.z, min_b.z, max_b.z)

func clamp_position(position: Vector3, margin : float = 0) -> Vector3:
	var min_b := global_transform.origin - size / 2 + Vector3(margin, 0, margin) + Vector3(global_margin, 0, global_margin)
	var max_b := global_transform.origin + size / 2 - Vector3(margin, 0, margin) - Vector3(global_margin, 0, global_margin)
	position.x = clampf(position.x, min_b.x, max_b.x)
	position.z = clampf(position.z, min_b.z, max_b.z)
	return position

func mirror_position(position: Vector3) -> Vector3:
	# mirror the position across the edge of the map to ensure it's always a valid point, and return the mirrored position
	var min_b := global_transform.origin - size / 2 + Vector3(global_margin, 0, global_margin)
	var max_b := global_transform.origin + size / 2 - Vector3(global_margin, 0, global_margin)
	if position.x < min_b.x:
		position.x = min_b.x + (min_b.x - position.x)
	elif position.x > max_b.x:
		position.x = max_b.x - (position.x - max_b.x)
	if position.z < min_b.z:
		position.z = min_b.z + (min_b.z - position.z)
	elif position.z > max_b.z:
		position.z = max_b.z - (position.z - max_b.z)
	return position

func check_in_bounds(position: Vector3, margin : float = 0) -> bool:
	var min_b := global_transform.origin - size / 2 + Vector3(margin, 0, margin) + Vector3(global_margin, 0, global_margin)
	var max_b := global_transform.origin + size / 2 - Vector3(margin, 0, margin) - Vector3(global_margin, 0, global_margin)
	return position.x >= min_b.x and position.x <= max_b.x and position.z >= min_b.z and position.z <= max_b.z



