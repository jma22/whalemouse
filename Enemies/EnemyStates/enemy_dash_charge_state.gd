class_name EnemyDashChargeState extends EnemyChargeStateBase


var pivot : Vector3
@export var charge_creep_speed : float = 3


func enter() -> void:
	super()
# 	entity.sprite_manager.play(animation)
	pivot = entity.global_transform.origin
# 	stagger_stamina = max_stagger_stamina
# 	target_set = false

# func run(_delta: float) -> void:
# 	var facing_left : bool = entity.global_transform.origin.x > entity.player.global_transform.origin.x
# 	entity.set_sprite_flip(facing_left)
# 	check_state()

func fixed_run(_delta: float) -> void:
	super(_delta)
	var opposite_direction : Vector3 = (pivot - entity.player.global_transform.origin).normalized()
	var target_position : Vector3 = pivot + opposite_direction * charge_creep_speed * get_elapsed_time() * GlobalStats.get_enemy_attack_speed_multiplier()
	var direction : Vector3 = (target_position - entity.global_transform.origin).normalized()
	direction.y = 0
	entity.velocity = direction * charge_creep_speed * GlobalStats.get_enemy_attack_speed_multiplier() * _delta


func choose_target() -> Vector3:
	return entity.player.global_transform.origin
