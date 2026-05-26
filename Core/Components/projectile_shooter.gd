extends Node3D
class_name ProjectileShooter

@export var projectile_scene : PackedScene
@export var speed_multiplier : float = 1.0
@export var shooting_time : float = 0.3
@export var base_num_bullets : int = 3
@export var angle_between_bullets_degrees : float = 4.0

var entity : CharacterBody3D
var _burst_direction : Vector3 = Vector3.ZERO
var _burst_target : Node3D = null
var _bullets_fired : int = 0
var _burst_elapsed : float = 0.0
var _burst_active : bool = false
var _active_projectiles : Array[Node] = []


func setup(entity_: CharacterBody3D) -> void:
	entity = entity_


func start_burst(direction: Vector3, target: Node3D = null) -> void:
	_burst_direction = direction
	_burst_target = target
	_bullets_fired = 0
	_burst_elapsed = 0.0
	_burst_active = true


func tick(delta: float) -> void:
	if not _burst_active:
		return
	_burst_elapsed += delta
	var num_bullets : int = get_num_bullets()
	while _bullets_fired < num_bullets \
			and _burst_elapsed >= shooting_time / num_bullets * _bullets_fired:
		_shoot(_rotated_direction(_bullets_fired, num_bullets))
		_bullets_fired += 1
	if _bullets_fired >= num_bullets:
		_burst_active = false


func is_burst_done() -> bool:
	return not _burst_active


func get_num_bullets() -> int:
	return base_num_bullets + entity.get_projectile_flat()


func free_all() -> void:
	for p in _active_projectiles:
		if is_instance_valid(p):
			p.queue_free()
	_active_projectiles.clear()


func _rotated_direction(index: int, num_bullets: int) -> Vector3:
	var angle_between : float = deg_to_rad(angle_between_bullets_degrees)
	var angle_offset : float = angle_between * (index - (num_bullets - 1) / 2.0)
	return Vector3(
		_burst_direction.x * cos(angle_offset) - _burst_direction.z * sin(angle_offset),
		0,
		_burst_direction.x * sin(angle_offset) + _burst_direction.z * cos(angle_offset)
	)


func _shoot(direction: Vector3) -> void:
	_active_projectiles = _active_projectiles.filter(is_instance_valid)
	var instance : Node = projectile_scene.instantiate()
	entity.get_parent().add_child(instance)
	instance.global_transform.origin = entity.global_transform.origin
	instance.setup(direction, entity, speed_multiplier, _burst_target)
	_active_projectiles.append(instance)
