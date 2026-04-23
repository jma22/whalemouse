class_name Hitbox
extends Area3D

@export var owner_entity: Node3D
@export var hit_box_type: HitBoxType = HitBoxType.HIT_PLAYER
@export var damage_type : DamageInfo.DamageType = DamageInfo.DamageType.MELEE
@onready var sprite3D : Sprite3D = $Sprite3D
@export var damage: int = 1
@export var hitstop : HitStop

var source : Node3D
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
	b.hitbox = self


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

func build_damage_info(_target: Node3D) -> DamageInfo:
	var info : DamageInfo = DamageInfo.new()
	info.hitbox = self
	info.owner_entity = owner_entity
	info.source = source if source != null else owner_entity
	info.damage_type = damage_type
	info.amount = _compute_base_amount(info)
	return info

func _compute_base_amount(info: DamageInfo) -> int:
	if hit_box_type == HitBoxType.HIT_PLAYER:
		var base : int = StatCalculator.get_enemy_damage()
		print("calculating source damage multiplier for ", info.source)
		if info.source is EnemyBase:
			print("source is EnemyBase with status effect manager ", info.source.status_effect_manager.get_damage_multiplier())
			base = int(ceil(base * info.source.status_effect_manager.get_damage_multiplier()))
		return base
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
