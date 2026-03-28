extends Camera3D

@export var target : Node3D = null
@export var offset : Vector3 = Vector3(0, 8, 8)
@export var smooth_speed : float = 5.0

func _process(delta: float) -> void:
	if target == null:
		return
	var desired_position : Vector3 = target.global_position + offset
	global_position = global_position.lerp(desired_position, smooth_speed * delta)
