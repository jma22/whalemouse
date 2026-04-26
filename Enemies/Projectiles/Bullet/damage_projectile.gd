# bullet.gd
extends ProjectileBase

const BASE_SPEED: float = 1.5
var direction: Vector3 = Vector3.ZERO
var lifetime: float = 5.0
@export var hitbox : Hitbox
# var floor : FloorNav
var speed_multiplier : float = 1.0

func _ready() -> void:
	hitbox.damage_type = DamageInfo.DamageType.BULLET

func setup(direction_: Vector3, source_: Node3D, speed_multiplier: float) -> void:
	super.set_source(source_)
	hitbox.source = source_
	self.direction = direction_
	self.speed_multiplier = speed_multiplier
	hitbox.set_active(true)
	# cleanup timer
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
	# floor = hitbox.owner_entity.get_floor()

func _physics_process(delta: float) -> void:
	global_position += direction * get_speed() * delta
	# if floor and not floor.check_in_bounds(global_position):
	# 	queue_free()
	
func on_hitbox_hit() -> void:
	queue_free()

func get_speed() -> float:
	return BASE_SPEED * StatCalculator.get_enemy_attack_speed_multiplier() * speed_multiplier