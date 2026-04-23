extends EnemyBase
class_name AnglerEye

@onready var enemy_idle_state : EnemyIdleState = $StateMachine/EnemyIdleState
@onready var hurt_state : EnemyHurtState = $StateMachine/EnemyHurtState
@onready var walk_state : EnemyWalkState = $StateMachine/EnemyWalkState
@onready var enemy_attack_state : EnemyAttackParentState = $StateMachine/EnemyAttackParentState
# @onready var retreat_state : EnemyRetreatState = $StateMachine/EnemyRetreatState

# @onready var peaceful_state : EnemyPeacefulState = $StateMachine/EnemyPeacefulState

var detection_range : float = 2.5
var linked_boss : EnemyBase
var checkpoints : Array[Vector3] = []
var at_checkpoint : int = 0

var times_to_walk : int = 2
var walks_done : int = 0

func setup(player: CharacterBody3D, map: NavigationRegion3D) -> void:
	enemy_idle_state.set_idle_duration(0.5)
	initial_state = enemy_idle_state
	for node : Node3D in get_tree().get_nodes_in_group("eye_checkpoints"):
		checkpoints.append(node.global_position)
	super(player, map)
	health_component.max_health += StatCalculator.get_extra_boss_health()
	health_component.current_health = health_component.max_health
	hurt_box.orbs_on_hit = StatCalculator.get_boss_xp_drop_per_hit()

func set_variant(variant : int) -> void:
	match variant:
		0:
			sprite_manager.modulate = Color(1.0, 1.0, 1.0)
			enemy_attack_state.attack_state.set_rotated(false)
		1:
			sprite_manager.modulate = Color(0.5, 0.5, 1.0)
			enemy_attack_state.attack_state.set_rotated(true)


func check_state() -> void:
	if state_machine.current_state.is_complete:
		if state_machine.current_state == hurt_state:
			walk_state.set_target_position(get_random_checkpoint())
			state_machine.set_state(walk_state)
		elif state_machine.current_state == enemy_idle_state:
			walk_state.set_target_position(get_random_checkpoint())
			state_machine.set_state(walk_state)

		elif state_machine.current_state == walk_state:
			if walks_done < times_to_walk:
				walks_done += 1
				walk_state.set_target_position(get_random_checkpoint())
				state_machine.set_state(enemy_idle_state)
			else:
				walks_done = 0
				state_machine.set_state(enemy_attack_state)

		elif state_machine.current_state == enemy_attack_state:
			enemy_idle_state.set_idle_duration(0.2)
			times_to_walk = randi_range(0, 3)
			state_machine.set_state(enemy_idle_state)

func link_boss(boss :EnemyBase) -> void:
	linked_boss = boss

func get_escape_position() -> Vector3:
	var direction_away : Vector3 = (global_transform.origin - player.global_transform.origin).normalized()
	# var angle_offset : float = randf_range(-PI / 3.0, PI / 3.0)  # up to 60 degrees off center
	# var rotated_direction : Vector3 = Vector3(
	# 	direction_away.x * cos(angle_offset) - direction_away.z * sin(angle_offset),
	# 	direction_away.y,
	# 	direction_away.x * sin(angle_offset) + direction_away.z * cos(angle_offset)
	# )
	var target_location : Vector3= global_transform.origin + direction_away * randf_range(0.5, 1.5)
	# target_location = get_floor().clamp_position(target_location, 0.5)
	target_location = get_floor().mirror_position(target_location)
	return target_location

func get_random_checkpoint() -> Vector3:
	## checkpoint that isnt the current one
	if checkpoints.size() == 0:
		return global_transform.origin
	var next_index : int = randi_range(0, checkpoints.size() - 1)
	if at_checkpoint == next_index:
		next_index = (next_index + 1) % checkpoints.size()
	at_checkpoint = next_index
	return checkpoints[next_index]
# func check_range() -> void:
# 	var distance_to_player : float = global_transform.origin.distance_to(player.global_transform.origin)
# 	if distance_to_player <= detection_range:
# 		state_machine.set_state(retreat_state)
# 	else:
# 		state_machine.set_state(peaceful_state)

func on_hit(info: DamageInfo) -> void:
	super(info)
	linked_boss.on_hit(info)

func on_die() -> void:
	if is_dead:
		return
	super()
	linked_boss.on_eye_died()

# func on_staggered() -> void:
# 	hurt_state.set_idle_duration(0.2)
# 	state_machine.set_state(hurt_state)
