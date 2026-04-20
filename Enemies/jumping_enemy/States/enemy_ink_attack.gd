extends State

class_name EnemyInkAttackState

@export var animation : AnimationClip
# @export var map : MapManagerBase
# @export var charge_time : float = 1.0
# var set_target_time : float = 0.99
# var target_set : bool = false
# @export var charge_creep_speed : float = 0.5
# var pivot : Vector3
# @export var attack_state : EnemyJumpAttackState
# var stagger_stamina : int = 1
# @export var max_stagger_stamina : int = 1
var spawn_time : float = 0.3
var base_spawn_amount : int = 2
var spawn_timer : float = 0.0
var spawned_count : int = 0
var target_position : Vector3

var ink_projectile_scene : PackedScene = preload("res://Enemies/Projectiles/InkBall/ink_ball.tscn")

func enter() -> void:
	entity.sprite_manager.play(animation)
	spawn_timer = 0.0
	spawned_count = 0

func run(_delta: float) -> void:
	var facing_left : bool = entity.global_transform.origin.x > entity.player.global_transform.origin.x
	entity.set_sprite_flip(facing_left)
	check_state()
	spawn_timer += _delta
	if spawn_timer >= spawn_time:
		spawn_timer = 0.0
		spawn_ink()

func spawn_ink() -> void:
	var spawn_position : Vector3= sample_position_around_entity()
	var ink_instance : Node = ink_projectile_scene.instantiate()
	ink_instance.global_transform.origin = entity.global_transform.origin
	get_tree().get_root().add_child(ink_instance)
	ink_instance.setup(spawn_position)
	spawned_count += 1

func fixed_run(delta: float) -> void:
	entity.velocity = Vector3.ZERO

func exit() -> void:
	entity.position.y = 0
	entity.velocity.y = 0


func check_state() -> void:
	if spawned_count >= get_spawn_amount():
		is_complete = true

func sample_position_around_entity() -> Vector3:
	var radius : float = get_radius()
	var angle : float = randf() * 2.0 * PI
	var offset : Vector3 = Vector3(cos(angle), 0, sin(angle)) * radius

	var ball_radius : float = 0.3
	var sample_position : Vector3 = entity.global_transform.origin + offset
	var clamped_position : Vector3 = entity.get_floor().clamp_position(sample_position, ball_radius)
	return clamped_position 

func get_spawn_amount() -> int:
	return base_spawn_amount + GlobalStats.get_enemy_projectile_flat()

func get_radius() -> float:
	return randf_range(1.0, 1.6 * GlobalStats.get_enemy_attack_speed_multiplier())

# func set_target_position(position: Vector3) -> void:
# 	target_position = position
# 	print("Target position set to: ", target_position)