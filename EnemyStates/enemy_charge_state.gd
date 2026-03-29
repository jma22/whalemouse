extends State

class_name EnemyChargeState

@export var charge_time : float = 1.0
@export var charge_creep_speed : float = 0.5
var pivot : Vector3
@export var attack_state : EnemyAttackState

func enter() -> void:
	pivot = entity.global_transform.origin

func run(_delta: float) -> void:
	check_state()

func fixed_run(_delta: float) -> void:
	set_velocity()
	entity.move_and_slide()


func check_state() -> void:
	if charge_time <= get_elapsed_time():
		entity.velocity = Vector3.ZERO
		attack_state.set_target_position(entity.player.global_transform.origin)
		is_complete = true

func set_velocity() -> void:
	var opposite_direction : Vector3 = (pivot - entity.player.global_transform.origin).normalized()
	var target_position : Vector3 = pivot + opposite_direction * charge_creep_speed * get_elapsed_time()
	var direction : Vector3 = (target_position - entity.global_transform.origin).normalized()
	entity.velocity = direction * charge_creep_speed
