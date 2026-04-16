extends State

class_name EnemyJumpAttackState
var target_position : Vector3
@export var animation_clip : AnimationClip
@export var hit_box_time : float = 0.05
@export var hitbox : Hitbox

var cooldown_time : float = 0.4
var cooldown_timer : float = 0.0
var start_cooldown : bool = false

@export var arc_component : ArcComponent


# @export var audio_player : AudioStreamPlayer
var bubbler_scene : PackedScene = load("res://VFX/bubbler.tscn")
var xp_spawner_scene : PackedScene = load("res://Collectibles/xp_spawner.tscn")
var impact_effect_scene : PackedScene = load("res://VFX/Impact/impact_vfx.tscn")
func enter() -> void:
	entity.sprite_manager.play(animation_clip)
	# audio_player.pitch_scale = 1.5 + randf() * 0.2
	# audio_player.play()
	arc_component.setup(target_position)
	entity.knockback_component.set_knockbackable(false)
	var bubbler_instance : Node = bubbler_scene.instantiate()
	# bubbler_instance.global_transform.origin = entity.global_transform.origin
	entity.add_child(bubbler_instance)
	bubbler_instance.start()
	entity.hurt_box.set_active(false)
	start_cooldown = false
	cooldown_timer = 0.0


# func exit() -> void:
# 	entity.hitbox.set_active(false)
# 	entity.knockback_component.set_knockbackable(true)

func run(_delta: float) -> void:
	check_state()
	if start_cooldown:
		cooldown_timer += _delta
		

func fixed_run(_delta: float) -> void:
	if start_cooldown:
		entity.velocity = Vector3.ZERO
		return 
	arc_component.tick(_delta)
	entity.velocity = arc_component.velocity

	var t : float = get_elapsed_time() / arc_component.time
	t = clamp(t, 0, 1)


	if t >= 1- hit_box_time and not hitbox.is_active:
		hitbox.set_active(true)

	if t >= 0.9 and entity.position.y <= 0.01:
		entity.position.y = 0
		entity.velocity.y = 0

		# var xp_spawner_instance : Node = xp_spawner_scene.instantiate()
		var impact_effect_instance : Node = impact_effect_scene.instantiate()
		get_tree().get_root().add_child(impact_effect_instance)
		impact_effect_instance.global_transform.origin = entity.global_transform.origin
		impact_effect_instance.play()

		start_cooldown = true
		entity.hurt_box.set_active(true)
		hitbox.set_active(false)
		entity.knockback_component.set_knockbackable(true)

	
func set_target_position(position: Vector3) -> void:
	target_position = position

func check_state() -> void:
	if cooldown_timer >= cooldown_time:
		is_complete = true


	
