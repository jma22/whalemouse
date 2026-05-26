# bullet.gd
extends ProjectileBase

const BASE_SPEED: float = 1.2
const HOMING_TIME: float = 3.0
const TURN_STRENGTH: float = 6.0   # higher = snappier turning

var direction: Vector3 = Vector3.ZERO
var lifetime: float = 5.0
var speed_multiplier: float = 1.0
var target: Node3D = null
var homing_elapsed: float = 0.0

@export var hitbox: Hitbox
@export var projectile_sprite: SpriteManager

func _ready() -> void:
	hitbox.damage_type = DamageInfo.DamageType.BULLET

func setup(direction_: Vector3, source_: Node3D, speed_multiplier_: float, target_: Node3D) -> void:
	super.set_source(source_)
	hitbox.source = source_
	self.direction = direction_
	self.direction.z *= Constants.VERTICAL_PERSRPECTIVE_SCALE
	self.direction = self.direction.normalized()
	self.speed_multiplier = speed_multiplier_
	self.target = target_
	hitbox.set_active(true)
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	_update_homing(delta)
	global_position += direction * get_speed() * delta

func _update_homing(delta: float) -> void:
	if homing_elapsed >= HOMING_TIME:
		return
	if not is_instance_valid(target):
		return  # target died/freed — coast straight
	homing_elapsed += delta
	var to_target := target.global_position - global_position
	to_target.z *= Constants.VERTICAL_PERSRPECTIVE_SCALE
	direction = direction.lerp(to_target.normalized(), TURN_STRENGTH * delta).normalized()

func on_hitbox_hit() -> void:
	queue_free()

func get_speed() -> float:
	return BASE_SPEED * StatCalculator.get_enemy_attack_speed_multiplier() * speed_multiplier
