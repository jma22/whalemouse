extends State

class_name EnemyJumpAttackChargeState

@export var animation : AnimationClip
@export var charge_time : float = 0.5
var set_target_time : float = 0.4
var target_set : bool = false
@export var charge_creep_speed : float = 0.5
var pivot : Vector3
@export var attack_state : EnemyJumpAttackState
var stagger_stamina : int = 1
@export var max_stagger_stamina : int = 1

func enter() -> void:
	entity.sprite_manager.play(animation)
	pivot = entity.global_transform.origin
	stagger_stamina = max_stagger_stamina
	target_set = false

func run(_delta: float) -> void:
	var facing_left : bool = entity.global_transform.origin.x > entity.player.global_transform.origin.x
	entity.set_sprite_flip(facing_left)
	check_state()

func fixed_run(delta: float) -> void:
	entity.velocity = Vector3.ZERO

func exit() -> void:
	entity.position.y = 0
	entity.velocity.y = 0


func check_state() -> void:
	if set_target_time /  GlobalStats.get_enemy_speed_multiplier() <= get_elapsed_time() and not target_set:
		attack_state.set_target_position(sample_position_around_entity())
		target_set = true
	if charge_time / GlobalStats.get_enemy_speed_multiplier() <= get_elapsed_time() :
		entity.velocity = Vector3.ZERO
		# attack_state.set_target_position(entity.player.global_transform.origin)
		is_complete = true

# func set_velocity() -> void:
# 	var opposite_direction : Vector3 = (pivot - entity.player.global_transform.origin).normalized()
# 	var target_position : Vector3 = pivot + opposite_direction * charge_creep_speed * get_elapsed_time() * GlobalStats.get_enemy_speed_multiplier()
# 	var direction : Vector3 = (target_position - entity.global_transform.origin).normalized()
# 	direction.y = 0
# 	entity.velocity = direction * charge_creep_speed * GlobalStats.get_enemy_speed_multiplier()

func sample_position_around_entity() -> Vector3:
	var angle : float = randf() * 2.0 * PI
	var radius : float = randf_range(1.8, 2.3)
	var offset : Vector3 = Vector3(cos(angle), 0, sin(angle)) * radius
	var target_point : Vector3 = entity.global_transform.origin + offset
	# print("vector jump", vec)

	# var aabb = entity.get_floor().get_bounds()
	# var min_x = aabb.position.x
	# var max_x = aabb.position.x + aabb.size.x
	# var min_z = aabb.position.z
	# var max_z = aabb.position.z + aabb.size.z
	# var spawn_x = clamp(entity.global_transform.origin.x + offset.x, min_x, max_x)
	# var spawn_z = clamp(entity.global_transform.origin.z + offset.z, min_z, max_z)

	var map : AABB = entity.get_floor().get_bounds()
	if not map.has_point(target_point):
		print("flipping")
		if target_point.x < map.position.x:
			# mirror across the edge of the map to ensure it's always a valid point
			target_point.x = map.position.x + (map.position.x - target_point.x) *2
		elif target_point.x > map.position.x + map.size.x:
			target_point.x = map.position.x + map.size.x - (target_point.x - (map.position.x + map.size.x)) *2
		if target_point.z < map.position.z:
			target_point.z = map.position.z + (map.position.z - target_point.z)*2
		elif target_point.z > map.position.z + map.size.z:
			target_point.z = map.position.z + map.size.z - (target_point.z - (map.position.z + map.size.z))*2
	target_point.y = 0
	
	return target_point
func on_hit(damage : int) -> void:
	stagger_stamina -= damage
	if stagger_stamina <= 0:
		entity.on_staggered()
