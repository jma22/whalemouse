extends NavigationRegion3D
class_name FloorNav
@export var floor_material: MeshInstance3D

var material : ShaderMaterial
var player : CharacterBody3D
# var discrete_time : float = 0.01
var time_accumulator : float = 0.0

var offset : Vector2 = Vector2(0,0.45)
func setup(player : CharacterBody3D, camera : Camera3D) -> void:
	material = floor_material.get_surface_override_material(0) as ShaderMaterial
	self.player = player
	## set size of the mesh in shader parameters
	material.set_shader_parameter("world_size", Vector2(8,4.4))
	material.set_shader_parameter("world_origin", Vector2(global_transform.origin.x, global_transform.origin.z) - Vector2(4,2))

func _process(delta: float) -> void:
	# time_accumulator += delta
	# if time_accumulator >= discrete_time:
	# 	time_accumulator -= discrete_time
	if not player:
		return
	var pos = player.global_position
	material.set_shader_parameter("world_center", Vector2(pos.x, pos.z) + offset)
	material.set_shader_parameter("shadow_center", Vector2(pos.x, pos.z) + offset/2)
