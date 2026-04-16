extends State

class_name EnemyAuraActivateState
var target_position : Vector3
@export var animation_clip : AnimationClip
@export var attack_speed : float = 12.0
@export var dampening : float = 0.88
@export var attack_duration : float = 0.5
# @export var audio_player : AudioStreamPlayer
@export var hitbox : Hitbox
@export var aura : FloorEffectBase

var aura_time : float = 5.0


func enter() -> void:
	entity.sprite_manager.play(animation_clip)
	# audio_player.pitch_scale = 1.5 + randf() * 0.2
	# audio_player.play()
	# hitbox.set_active(true)
	# apply_velocity()
	aura.activate_aura(aura_time)
	# entity.knockback_component.set_knockbackable(false)
	# var bubbler_instance : Node = bubbler_scene.instantiate()
	# bubbler_instance.global_transform.origin = entity.global_transform.origin
	# entity.add_child(bubbler_instance)
	# bubbler_instance.start()


# func exit() -> void:
	# hitbox.set_active(false)
	# entity.knockback_component.set_knockbackable(true)

# func run(_delta: float) -> void:
# 	check_state()

func fixed_run(_delta: float) -> void:
	entity.velocity *= dampening

	if get_elapsed_time() >= attack_duration:
		is_complete = true

# func set_target_position(position: Vector3) -> void:
# 	target_position = position

# func check_state() -> void:
# 	pass

# func apply_velocity()-> void:
# 	if target_position == null:
# 		return
# 	var direction : Vector3 = (target_position - entity.global_transform.origin)
# 	direction.y = 0
# 	direction = direction.normalized()
# 	var velocity : Vector3 = direction * attack_speed * GlobalStats.get_enemy_speed_multiplier()
# 	entity.velocity = velocity
