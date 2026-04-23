class_name Hitbox
extends Area3D

@export var owner_entity: Node3D
@export var hit_box_type: HitBoxType = HitBoxType.HIT_PLAYER
@onready var sprite3D : Sprite3D = $Sprite3D
@export var damage: int = 1
@export var hitstop : HitStop

var is_active: bool = false
var effect_on_hit : StatusEffectBase = null
var behavior : HitboxBehavior = null

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

func set_damage(damage_amount: int) -> void:
	damage = damage_amount

func set_effect_on_hit(effect: StatusEffectBase) -> void:
	effect_on_hit = effect

func set_behavior(b: HitboxBehavior) -> void:
	behavior = b

	
func set_active(active: bool) -> void:
	self.set_deferred("monitorable", active)
	## show visible
	if sprite3D:
		sprite3D.visible = active
	is_active = active

func hitbox_on_hit() -> void:
	if owner_entity and owner_entity.has_method("on_hitbox_hit"):
		owner_entity.on_hitbox_hit()

	if hitstop:
		hitstop.start_hitstop(0.1)

func get_damage() -> int:
	if hit_box_type == HitBoxType.HIT_PLAYER:
		var base : int = StatCalculator.get_enemy_damage()
		if owner_entity is EnemyBase:
			base = int(ceil(base * owner_entity.status_effect_manager.get_damage_multiplier()))
		return base
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
