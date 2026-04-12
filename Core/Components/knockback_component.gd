extends Node3D
class_name KnockbackComponent

@export var knockback_mult : float = 15.0
@export var knockback_dampening : float = 0.8
@export var knockback_velocity : Vector3 = Vector3.ZERO
@export var is_knockbackable : bool = true
@export var entity: CharacterBody3D

func handle_knockback() -> void:
	if not is_knockbackable:
		return
	if knockback_velocity.length() > 1.0:
		knockback_velocity *= knockback_dampening
		entity.velocity += knockback_velocity
	else:
		knockback_velocity = Vector3.ZERO

func set_knockbackable(value: bool) -> void:
	is_knockbackable = value

func receive_knockback(direction: Vector3, force: float) -> void:
	direction.y = 0
	knockback_velocity = direction.normalized() * force * knockback_mult