extends Node3D

@export var player: Node3D
@export var camera: Camera3D
@export var foreground_material: ShaderMaterial

func _process(_delta: float) -> void:
	if not (player and camera and foreground_material):
		return

	var viewport_size: Vector2 = get_viewport().get_visible_rect().size

	# If player is behind the camera, unproject_position returns garbage —
	# clamp or hide the hole in that case.
	if camera.is_position_behind(player.global_position):
		# park it offscreen so the hole disappears
		foreground_material.set_shader_parameter("player_screen_uv", Vector2(-10.0, -10.0))
		return

	var screen_pos: Vector2 = camera.unproject_position(player.global_position)

	foreground_material.set_shader_parameter("player_screen_uv", screen_pos / viewport_size)