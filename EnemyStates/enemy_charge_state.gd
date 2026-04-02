extends State

class_name EnemyChargeState

@export var animation : AnimationClip
@export var charge_time : float = 1.0
@export var charge_creep_speed : float = 0.5
var pivot : Vector3
@export var attack_state : EnemyAttackState
var stagger_stamina : int = 1
@export var max_stagger_stamina : int = 1

func enter() -> void:
	entity.sprite_manager.play(animation)
	pivot = entity.global_transform.origin
	stagger_stamina = max_stagger_stamina

func run(_delta: float) -> void:
	check_state()

func fixed_run(_delta: float) -> void:
	set_velocity()

func exit() -> void:
	entity.position.y = 0
	entity.velocity.y = 0


func check_state() -> void:
	if charge_time <= get_elapsed_time() / GlobalStats.get_enemy_speed_multiplier():
		entity.velocity = Vector3.ZERO
		attack_state.set_target_position(entity.player.global_transform.origin)
		is_complete = true

func set_velocity() -> void:
	var opposite_direction : Vector3 = (pivot - entity.player.global_transform.origin).normalized()
	var target_position : Vector3 = pivot + opposite_direction * charge_creep_speed * get_elapsed_time() * GlobalStats.get_enemy_speed_multiplier()
	var direction : Vector3 = (target_position - entity.global_transform.origin).normalized()
	direction.y = 0
	entity.velocity = direction * charge_creep_speed * GlobalStats.get_enemy_speed_multiplier()

func on_hit(damage : int) -> void:
	stagger_stamina -= damage
	if stagger_stamina <= 0:
		entity.on_staggered()
