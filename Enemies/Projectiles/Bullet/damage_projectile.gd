# bullet.gd
extends Node3D

const BASE_SPEED: float = 1.5
var direction: Vector3 = Vector3.ZERO
var lifetime: float = 5.0
@export var hitbox : Hitbox
# var floor : FloorNav
var speed_multiplier : float = 1.0
@export var projectile_sprite : SpriteManager

func _ready() -> void:
	hitbox.damage_type = DamageInfo.DamageType.BULLET

func setup(direction_: Vector3, owner_: Node3D, speed_multiplier_: float, _target: Node3D = null) -> void:
	hitbox.set_owner_entity(owner_)
	hitbox.hit_registered.connect(on_hitbox_hit)
	self.direction = direction_
	self.direction.z *= Constants.VERTICAL_PERSRPECTIVE_SCALE
	self.speed_multiplier = speed_multiplier_
	hitbox.set_active(true)
	# cleanup timer
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
	## flip sprite based on direction
	# if direction.x < 0:
		
	# floor = hitbox.owner_entity.get_floor()

func _physics_process(delta: float) -> void:
	global_position += direction * get_speed() * delta
	# if floor and not floor.check_in_bounds(global_position):
	# 	queue_free()
	
func on_hitbox_hit() -> void:
	queue_free()

func get_speed() -> float:
	return BASE_SPEED * StatCalculator.get_enemy_attack_speed_multiplier() * speed_multiplier