extends Node3D

class_name CollectibleSpawner
@export var xp_orb: PackedScene
@export var ebb_orb: PackedScene

enum OrbType {
	TIME,
	EBB
}
var spawned_orbs: Array = []
var orb_lifetime: float = 5.0
var spawn_timer: float = 0.0


func setup_outwards(num_orbs: int, target_: Node3D, orb_type: OrbType, floor_: FloorNav) -> void:
	for i in range(num_orbs):
		var orb_instance : Node3D = spawn_orb(orb_type)
	
		var angle : float = (TAU / num_orbs) * i
		var xz_dir : Vector2 = Vector2(cos(angle), sin(angle))
		var scatter_speed : float = randf_range(5.0, 12.0)
		xz_dir *= scatter_speed
		var upward_pop : float = randf_range(2.0, 4.0)
		var velocity : Vector3 = Vector3(xz_dir.x , upward_pop, xz_dir.y)
		orb_instance.setup(velocity, target_, floor_)

func setup_directional(num_orbs: int, target_: Node3D, direction : Vector3, orb_type: OrbType, floor_: FloorNav	) -> void:
	for i : int in range(num_orbs):
		var orb_instance : Node3D = spawn_orb(orb_type)

		var spread : float = (TAU/6)
		var angle : float = (spread / num_orbs) * i - spread/2
		var xz_dir : Vector2 = Vector2(cos(angle), sin(angle)) + Vector2(direction.x,direction.z)
		xz_dir = xz_dir.normalized()
		var scatter_speed : float = randf_range(5.0, 12.0)
		xz_dir *= scatter_speed
		var upward_pop : float = randf_range(2.0, 4.0)
		var velocity : Vector3 = Vector3(xz_dir.x , upward_pop, xz_dir.y)
		orb_instance.setup(velocity, target_, floor_)

func spawn_orb(orb_type: OrbType) -> Node3D:
	var orb_instance : Node3D
	if orb_type == OrbType.TIME:
		orb_instance = xp_orb.instantiate()
	else:
		orb_instance = ebb_orb.instantiate()
	add_child(orb_instance)
	spawned_orbs.append(orb_instance)
	orb_instance.global_transform.origin = global_transform.origin
	return orb_instance


func _process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer >= orb_lifetime:
		for orb : Node3D in spawned_orbs:
			if orb:
				orb.queue_free()
		queue_free()
