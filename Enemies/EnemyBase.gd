@abstract
extends CharacterBody3D
class_name EnemyBase

@export var floor_ : FloorNav
@export var player : CharacterBody3D
var xp_spawner_scene : PackedScene = load("res://Collectibles/xp_spawner.tscn")

@onready var state_machine : StateMachine = $StateMachine

@onready var hitbox : Node = $Hitbox
# @onready var walk_state : WalkState = $StateMachine/WalkState
# @onready var enemy_idle_state : EnemyIdleState = $StateMachine/EnemyIdleState
# @onready var hurt_state : EnemyHurtState = $StateMachine/EnemyHurtState
# @onready var retreat_state : EnemyRetreatState = $StateMachine/EnemyRetreatState
# @onready var approach_state : EnemyPursuitState = $StateMachine/EnemyPursuitState
# @onready var attack_state : EnemyAttackState = $StateMachine/EnemyAttackState
# @onready var peaceful_state : EnemyPeacefulState = $StateMachine/EnemyPeacefulState
# @onready var charge_state : EnemyChargeState = $StateMachine/EnemyChargeState

@export var initial_health : int = 1
@export var initial_state : State
@export var xp_drop_amount : int = 1
@export var core_components : CoreComponents

@onready var health_component : HealthComponent = core_components.health_component
@onready var invulnerable_component : InvulnerableComponent = core_components.invulnerable_component
@onready var knockback_component : KnockbackComponent = core_components.knockback_component
@onready var hurt_box : HurtBox = core_components.hurt_box
@onready var sprite_manager : SpriteManager = core_components.sprite_manager
@onready var hitstop : HitStop = core_components.hitstop

var is_dead : bool = false
# var facing_left : bool = false
func setup(player_ : CharacterBody3D, floor_ : NavigationRegion3D) -> void:
	self.player = player_
	self.floor_ = floor_
	core_components.setup(self)
	setup_states()
	state_machine.set_state(initial_state)


# func _ready() -> void:
	
func _process(_delta: float) -> void:
	if is_dead or hitstop.is_in_hitstop:
		return
	if state_machine.current_state:
		check_state()
		state_machine.current_state.deep_run(_delta)
	# if facing_left:
	# 	sprite_manager.set_flip(true)
	# else:
	# 	sprite_manager.set_flip(false)

func _physics_process(delta: float) -> void:
	if is_dead or hitstop.is_in_hitstop:
		return
	
	if state_machine.current_state:
		state_machine.current_state.deep_fixed_run(delta)
	knockback_component.handle_knockback()
	move_and_slide()
	if floor_:
		floor_.clamp_body(self, knockback_component)


@abstract
func check_state() -> void

func setup_states() -> void:
	for state : Node in state_machine.find_children("*", "State", true, false):
		if state is State:
			state.set_entity(self)

func on_hit(attacker_hitbox: Hitbox) -> void:
	print("got hit in state:" + str(state_machine.current_state))
	if is_dead or invulnerable_component.is_currently_invulnerable():
		return
	sprite_manager.damage_flash()
	var damage_taken : int = attacker_hitbox.get_damage()
	print("damage taken: " + str(damage_taken))
	if damage_taken == 0:
		return
	health_component.take_damage(damage_taken)
	hurt_box.on_valid_damaging_hit()
	

	on_staggered()
	attacker_hitbox.hitbox_on_hit() #hitstop
	hitstop.start_hitstop(0.2)

	# if state_machine.current_state.has_method("on_hit"):
	# 	state_machine.current_state.on_hit(damage)
	var knockback_direction : Vector3 = (global_transform.origin - attacker_hitbox.owner_entity.global_transform.origin).normalized()

	if health_component.is_dead():
		on_die()
		knockback_component.receive_knockback(knockback_direction, 0.4*damage_taken)
		return

	knockback_component.receive_knockback(knockback_direction, damage_taken)


func on_die() -> void:
	if is_dead:
		return
	is_dead = true
	var tween : Tween = await sprite_manager.die()
	GlobalStats.add_kill()
	var should_drop_ebb : bool = GlobalStats.should_drop_ebb()


	await tween.finished
	if xp_spawner_scene:
		var xp_spawner_instance : Node = xp_spawner_scene.instantiate()
		get_parent().add_child(xp_spawner_instance)
		xp_spawner_instance.global_transform.origin = global_transform.origin
		if randf() < 0.5:
			xp_spawner_instance.setup_outwards(xp_drop_amount + GlobalStats.get_bonus_enemy_xp_drop(), player, CollectibleSpawner.OrbType.TIME, get_floor())
		else:
			xp_spawner_instance.setup_outwards(xp_drop_amount, player, CollectibleSpawner.OrbType.TIME, get_floor())

		if should_drop_ebb:
			xp_spawner_instance.setup_outwards(1, player, CollectibleSpawner.OrbType.EBB, get_floor())
			
	process_mode = Node.PROCESS_MODE_DISABLED	

func on_staggered() -> void:
	pass

func set_invulnerable(value: bool, duration: float = 0.0) -> void:
	invulnerable_component.set_invulnerable(value, duration)

func set_sprite_flip(left: bool) -> void:
	sprite_manager.set_flip(left)

func get_floor() -> NavigationRegion3D:
	return floor_
