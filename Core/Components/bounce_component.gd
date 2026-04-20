extends Node3D
class_name BounceComponent

@export var bounce_mult : float = 1.0
@export var bounce_dampening : float = 0.8
@export var bounce_velocity : Vector3 = Vector3.ZERO
var entity: CharacterBody3D


func setup(entity_: CharacterBody3D) -> void:
	entity = entity_

func handle_bounce() -> void:
	if bounce_velocity.length() > 1.0:
		bounce_velocity *= bounce_dampening
		entity.velocity += bounce_velocity
	else:
		bounce_velocity = Vector3.ZERO

# # In FloorNav
func clamp_and_bounce() -> void:
	var floor_ : FloorNav = entity.get_floor()
	var min_b := floor_.global_transform.origin - floor_.size / 2 + Vector3(floor_.global_margin, 0, floor_.global_margin)
	var max_b := floor_.global_transform.origin + floor_.size / 2 - Vector3(floor_.global_margin, 0, floor_.global_margin)
	var pos := entity.global_position
	var velocity_copy : Vector3 = entity.knockback_component.knockback_velocity
	var flipped : bool = false
	if pos.x < min_b.x or pos.x > max_b.x:
		flipped = true
		velocity_copy.x *= -bounce_mult
	if pos.z < min_b.z or pos.z > max_b.z:
		flipped = true
		velocity_copy.z *= -bounce_mult
	if flipped:
		bounce_velocity = velocity_copy

	entity.global_position.x = clampf(pos.x, min_b.x, max_b.x)
	entity.global_position.z = clampf(pos.z, min_b.z, max_b.z)
