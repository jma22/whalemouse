extends Node3D

@export var xp_orb: PackedScene
var spawned_orbs: Array = []
var orb_lifetime: float = 5.0
var spawn_timer: float = 0.0


func setup_outwards(num_orbs: int, target_: Node3D) -> void:
	for i in range(num_orbs):
		var orb_instance = xp_orb.instantiate()
		add_child(orb_instance)
		spawned_orbs.append(orb_instance)
		orb_instance.global_transform.origin = global_transform.origin
		var angle : float = (TAU / num_orbs) * i
		var xz_dir : Vector2 = Vector2(cos(angle), sin(angle))
		var scatter_speed : float = randf_range(5.0, 12.0)
		xz_dir *= scatter_speed
		var upward_pop : float = randf_range(2.0, 4.0)
		var velocity : Vector3 = Vector3(xz_dir.x , upward_pop, xz_dir.y)
		orb_instance.setup(velocity, target_)

func setup_directional(num_orbs, target_: Node3D, direction : Vector3) -> void:
	print("spawning")

	for i in range(num_orbs):
		var orb_instance = xp_orb.instantiate()
		add_child(orb_instance)
		spawned_orbs.append(orb_instance)
		orb_instance.global_transform.origin = global_transform.origin
		var spread : float = (TAU/6)
		var angle : float = (spread / num_orbs) * i - spread/2
		var xz_dir : Vector2 = Vector2(cos(angle), sin(angle)) + Vector2(direction.x,direction.z)
		xz_dir.normalized()
		var scatter_speed : float = randf_range(5.0, 12.0)
		xz_dir *= scatter_speed
		var upward_pop : float = randf_range(2.0, 4.0)
		var velocity : Vector3 = Vector3(xz_dir.x , upward_pop, xz_dir.y)
		orb_instance.setup(velocity, target_)


func _process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer >= orb_lifetime:
		for orb : Node3D in spawned_orbs:
			if orb:
				orb.queue_free()
		queue_free()
