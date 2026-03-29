class_name Hitbox
extends Area3D

@export var hit_box_type: HitBoxType = HitBoxType.HIT_PLAYER

enum HitBoxType {
	HIT_PLAYER,
	HIT_ENEMY
}

func _ready() -> void:
	monitorable = false
	set_collisions()
	set_active(true)

func set_active(active: bool) -> void:
	self.set_deferred("monitorable", active)
	## show visible
	visible = active


func get_damage() -> int:
	return 1


func set_collisions() -> void:
	match hit_box_type:
		HitBoxType.HIT_PLAYER:
			collision_layer = 1
			# collision_mask = 1
		HitBoxType.HIT_ENEMY:
			collision_layer = 2
			# collision_mask = 2