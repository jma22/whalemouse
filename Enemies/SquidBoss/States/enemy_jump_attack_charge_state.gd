extends State

class_name EnemyJumpAttackChargeState

@export var animation : AnimationClip
@export var charge_time : float = 1.0
var set_target_time : float = 0.35
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

# func fixed_run(_delta: float) -> void:
	# set_velocity()

func exit() -> void:
	entity.position.y = 0
	entity.velocity.y = 0


func check_state() -> void:
	if set_target_time /  GlobalStats.get_enemy_speed_multiplier() <= get_elapsed_time() and not target_set:
		attack_state.set_target_position(entity.player.global_transform.origin)
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

func on_hit(damage : int) -> void:
	stagger_stamina -= damage
	if stagger_stamina <= 0:
		entity.on_staggered()
