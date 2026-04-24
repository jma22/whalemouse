extends State

class_name AttackState

@export var animation: AnimationClip
@export var hitbox: Hitbox
@export var audio_player: AudioStreamPlayer
@export var arc_component: Node3D  # assign the arc Node3D in inspector

var attack_direction: Vector2 = Vector2.ZERO
var hitbox_frame: int = 4

var bubbler_scene: PackedScene = load("res://VFX/stomp_bubbler.tscn")
var crack_scene: PackedScene = load("res://VFX/crack.tscn")
var impact_effect_scene : PackedScene = load("res://VFX/Impact/impact_vfx.tscn")


var horizontal_distance : float = 0.7
var will_crit : bool = false
var num_attacks : int = 0

func enter() -> void:
	
	# entity.sprite_manager.frames_per_second = 12
	adjust_speed()
	entity.sprite_manager.play(animation, false)

	audio_player.pitch_scale = 0.9 + randf() * 0.2
	audio_player.play()

	# convert 2D attack direction to world position for the arc
	var dir3d := Vector3(attack_direction.x, 0, attack_direction.y)
	var target := entity.global_transform.origin + dir3d * horizontal_distance

	if StatCalculator.get_bigger_attack_every_n_hits() > 0:
		num_attacks += 1

	
	hitbox.scale = get_attack_size()	
	# scale arc params by attack speed multiplier
	# arc_component.time = 1.5 / spd_mult
	arc_component.setup(target)

	will_crit = randf() < StatCalculator.get_critical_chance()
	if will_crit:
		hitbox.set_damage(2)
		DebugLog.dbg("AttackState", "CRIT rolled (chance=%.2f) → dmg=2" % StatCalculator.get_critical_chance())
	else:
		hitbox.set_damage(1)
	# hitbox.set_effect_on_hit(MarkEffect.make())
	# hitbox.set_effect_on_hit(MarkEffect.make())
	hitbox.set_behavior(AttackHitboxBehavior.make())


func adjust_speed() -> void:
	var mult : float = StatCalculator.get_attack_speed_multiplier()
	arc_component.set_multiplier(1/mult)

	entity.sprite_manager.frames_per_second = 12 * mult


func run(_delta: float) -> void:
	if entity.sprite_manager.check_is_done():
		entity.velocity = Vector3.ZERO
		entity.position.y = 0
		is_complete = true

func fixed_run(delta: float) -> void:
	# apply arc velocity to entity
	arc_component.tick(delta)
	entity.velocity = arc_component.velocity

	if entity.sprite_manager.current_idx == hitbox_frame - 2:
		var bubbler := bubbler_scene.instantiate()
		entity.get_parent().add_child(bubbler)
		bubbler.global_transform.origin = entity.global_transform.origin + Vector3(0, -0.1, 0)
		bubbler.start()

	if entity.sprite_manager.current_idx == hitbox_frame and not hitbox.is_active:
		hitbox.set_active(true)
		var crack := crack_scene.instantiate() as Sprite3D
		entity.get_parent().add_child(crack)
		crack.global_transform = entity.global_transform
		crack.global_transform.origin.y = 0.01
		
		crack.set_scale(get_attack_size())
		crack.play()

		var impact_effect_instance : Node = impact_effect_scene.instantiate()
		get_tree().get_root().add_child(impact_effect_instance)
		impact_effect_instance.global_transform.origin = entity.global_transform.origin

		impact_effect_instance.setup(get_attack_size().x, will_crit)
		impact_effect_instance.play()
		if will_crit:
			entity.camera_ref.camera_shake(0.3,0.35)
		else:
			entity.camera_ref.camera_shake(0.1,0.15)


	if entity.velocity.y < 0 and abs(entity.position.y) < 0.05:
		entity.velocity = Vector3.ZERO
		entity.position.y = 0

func exit() -> void:
	entity.sprite_manager.frames_per_second = 12
	hitbox.set_active(false)

func set_direction(direction: Vector2) -> void:
	attack_direction = direction

func get_attack_size() -> Vector3:
	var base_scale := Vector3(StatCalculator.get_mouse_attack_hitbox_shrink(), 1, StatCalculator.get_mouse_attack_hitbox_shrink())
	if StatCalculator.get_bigger_attack_every_n_hits() > 0:
		if num_attacks % StatCalculator.get_bigger_attack_every_n_hits() == 0:
			base_scale *= 2.0
			DebugLog.dbg("AttackState", "bigger_attack_every_n_hits=%s → hit #%s is big (scale x2)" % [
				StatCalculator.get_bigger_attack_every_n_hits(), num_attacks
			])
	return base_scale
