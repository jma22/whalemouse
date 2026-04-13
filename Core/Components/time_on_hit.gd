extends Node3D

@export var xp_spawner_scene : PackedScene
@onready var hurtbox : HurtBox = get_parent()
# Called when the node enters the scene tree for the first time.



func spawn_time(num_orbs : int) -> void:
	if xp_spawner_scene:
		var xp_spawner_instance : Node3D = xp_spawner_scene.instantiate()
		get_tree().get_root().add_child(xp_spawner_instance)
		xp_spawner_instance.global_transform.origin = global_transform.origin
		var direction : Vector3 = hurtbox.owner_entity.global_transform.origin - hurtbox.owner_entity.player.global_transform.origin 
		xp_spawner_instance.setup_directional(num_orbs, hurtbox.owner_entity.player, direction.normalized(), CollectibleSpawner.OrbType.TIME)
