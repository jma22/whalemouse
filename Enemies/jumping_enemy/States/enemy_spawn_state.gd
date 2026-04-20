extends State

class_name EnemySpawnState

@export var animation : AnimationClip
# @export var charge_time : float = 1.0
# var set_target_time : float = 0.99
# var target_set : bool = false
# @export var charge_creep_speed : float = 0.5
# var pivot : Vector3
# @export var attack_state : EnemyJumpAttackState
# var stagger_stamina : int = 1
# @export var max_stagger_stamina : int = 1
var time_per_spawn : float = 0.5
var spawn_timer : float = 0.0
var spawned_count : int = 0
var enemy_spawner : EnemySpawner
var spawn_points : Array[Vector3] = []
var spawn_amount : int = 0
var spawn_name : String = ""


func enter() -> void:
	entity.sprite_manager.play(animation)
	spawn_timer = 0.0
	spawned_count = 0
	enemy_spawner = entity.enemy_spawner

func run(_delta: float) -> void:
	super(_delta)
	var facing_left : bool = entity.global_transform.origin.x > entity.player.global_transform.origin.x
	entity.set_sprite_flip(facing_left)
	spawn_timer += _delta
	if spawn_timer >= time_per_spawn:
		spawn_timer = 0.0
		spawn_enemy()
		spawned_count += 1
		if spawned_count >= spawn_amount:
			is_complete = true


func spawn_enemy() -> void:
	enemy_spawner.spawn_enemy(spawn_name, spawn_points[spawned_count])

# func fixed_run(delta: float) -> void:
# 	entity.velocity = Vector3.ZERO

func exit() -> void:
	entity.position.y = 0
	entity.velocity.y = 0


# func check_state() -> void:
# 	if spawned_count >= spawn_amount:
# 		is_complete = true

func set_spawn_info(spawn_name_ : String, points : Array[Vector3]) -> void:
	spawn_points = points
	spawn_name = spawn_name_
	spawn_amount = spawn_points.size()


# func sample_position_around_player(radius : float) -> Vector3:
# 	var angle : float = randf() * 2.0 * PI
# 	var offset : Vector3 = Vector3(cos(angle), 0, sin(angle)) * radius
# 	var target : Vector3 = entity.player.global_transform.origin + offset
# 	target.y = 0
# 	return target

# func on_hit(damage : int) -> void:
# 	stagger_stamina -= damage
# 	if stagger_stamina <= 0:
# 		entity.on_staggered()
