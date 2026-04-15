class_name EnemyChargeStateBase extends State


@export var animation : AnimationClip
@export var charge_time : float = 1.0
@export var set_target_time : float = 0.35

var target_set : bool = false

var stagger_stamina : int = 1
@export var max_stagger_stamina : int = 1

var attack_state : State


func enter() -> void:
	entity.sprite_manager.play(animation)
	stagger_stamina = max_stagger_stamina
	target_set = false

func run(_delta: float) -> void:
	var facing_left : bool = entity.global_transform.origin.x > entity.player.global_transform.origin.x
	entity.set_sprite_flip(facing_left)
	check_state()

# func fixed_run(_delta: float) -> void:
# 	set_velocity()

func exit() -> void:
	entity.position.y = 0
	entity.velocity.y = 0


func check_state() -> void:
	if set_target_time /  GlobalStats.get_enemy_speed_multiplier() <= get_elapsed_time() and not target_set:
		print("hi?")
		if attack_state.has_method("set_target_position"):
			print("bye?")
			attack_state.set_target_position(choose_target())
		target_set = true
	if charge_time / GlobalStats.get_enemy_speed_multiplier() <= get_elapsed_time() :
		entity.velocity = Vector3.ZERO
		# attack_state.set_target_position(entity.player.global_transform.origin)
		is_complete = true

func on_hit(damage : int) -> void:
	stagger_stamina -= damage
	if stagger_stamina <= 0:
		entity.on_staggered()


func choose_target() -> Vector3:
	return entity.player.global_transform.origin
