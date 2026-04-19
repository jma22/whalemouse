extends State

class_name EnemyDashAttackState
var target_position : Vector3
@export var animation_clip : AnimationClip
@export var attack_speed : float = 12.0
@export var dampening : float = 0.88
@export var hitbox_active_time : float = 0.2
@export var hitbox : Hitbox

@export var audio_player : AudioStreamPlayer
var bubbler_scene : PackedScene = load("res://VFX/bubbler.tscn")
func enter() -> void:
	entity.sprite_manager.play(animation_clip)
	audio_player.pitch_scale = 1.5 + randf() * 0.2
	audio_player.play()
	hitbox.set_active(true)
	apply_velocity()
	# entity.knockback_component.set_knockbackable(false)
	var bubbler_instance : Node = bubbler_scene.instantiate()
	# bubbler_instance.global_transform.origin = entity.global_transform.origin
	entity.add_child(bubbler_instance)
	bubbler_instance.start()


func exit() -> void:
# 	pass
	hitbox.set_active(false)
	# entity.knockback_component.set_knockbackable(true)

func run(_delta: float) -> void:
	check_state()
	if get_elapsed_time() >= hitbox_active_time:
		hitbox.set_active(false)

func fixed_run(_delta: float) -> void:
	entity.velocity *= dampening
	# if entity.velocity.length() < 0.2:
	# 	hitbox.set_active(false)
	if entity.velocity.length() < 1.0:
		is_complete = true

func set_target_position(position: Vector3) -> void:
	target_position = position

func check_state() -> void:
	pass

func apply_velocity()-> void:
	if target_position == null:
		return
	var direction : Vector3 = (target_position - entity.global_transform.origin)
	direction.y = 0
	direction = direction.normalized()
	var velocity : Vector3 = direction * attack_speed
	entity.velocity = velocity
