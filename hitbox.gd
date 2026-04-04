class_name Hitbox
extends Area3D

@export var hit_box_type: HitBoxType = HitBoxType.HIT_PLAYER
@onready var sprite3D : Sprite3D = $Sprite3D
@export var damage: int = 1
@export var hitstop : HitStop
var is_active: bool = false

enum HitBoxType {
	HIT_PLAYER,
	HIT_ENEMY
}

func _ready() -> void:
	# monitorable = false
	set_collisions()
	# set_active(true)
	set_active(false)
	if sprite3D:
		sprite3D.visible = false

func set_active(active: bool) -> void:
	self.set_deferred("monitorable", active)
	## show visible
	# if sprite3D:
	# 	sprite3D.visible = active
	is_active = active



func get_damage() -> int:
	if hitstop:
		hitstop.start_hitstop(0.1)
	if hit_box_type == HitBoxType.HIT_PLAYER:
		return GlobalStats.get_enemy_damage()
	else:
		return damage



func set_collisions() -> void:
	match hit_box_type:
		HitBoxType.HIT_PLAYER:
			collision_layer = 1
			# collision_mask = 1
		HitBoxType.HIT_ENEMY:
			collision_layer = 2
			# collision_mask = 2

func activate_hitbox() -> void:
	set_active(true)

func deactivate_hitbox() -> void:
	set_active(false)
