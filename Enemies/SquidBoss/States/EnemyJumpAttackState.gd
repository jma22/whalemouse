extends State

class_name EnemyJumpAttackState
var target_position : Vector3
@export var animation_clip : AnimationClip


var gravity : float = -2.0
var target_height : float = 1.5
var time :float = 2.0
var horizontal_dist : float = 1.0



# @export var audio_player : AudioStreamPlayer
var bubbler_scene : PackedScene = load("res://VFX/bubbler.tscn")
func enter() -> void:
	entity.sprite_manager.play(animation_clip)
	# audio_player.pitch_scale = 1.5 + randf() * 0.2
	# audio_player.play()
	apply_velocity()
	entity.knockback_component.set_knockbackable(false)
	var bubbler_instance = bubbler_scene.instantiate()
	# bubbler_instance.global_transform.origin = entity.global_transform.origin
	entity.add_child(bubbler_instance)
	bubbler_instance.start()


func exit() -> void:
	entity.hitbox.set_active(false)
	entity.knockback_component.set_knockbackable(true)

func run(_delta: float) -> void:
	check_state()

func fixed_run(_delta: float) -> void:
	# entity.velocity *= dampening
	# if entity.velocity.length() < 0.2:
	# 	entity.hitbox.set_active(false)
	# entity.velocity.x *= dampening
	# entity.velocity.z *= dampening
	# entity.velocity.y *= dampening*1.2
	entity.velocity.y += gravity * _delta
	if entity.velocity.y < 0 and abs(entity.position.y) < 0.1:
		entity.position.y = 0
		entity.velocity = Vector3.ZERO
		is_complete = true

func set_target_position(position: Vector3) -> void:
	target_position = position

func check_state() -> void:
	pass

func apply_velocity()-> void:
	if target_position == null:
		return
	var direction : Vector3 = (target_position - entity.global_transform.origin)
	direction.y = gravity * time * -1
	direction = direction.normalized()
	var velocity : Vector3 = direction * horizontal_dist / time
	entity.velocity = velocity
