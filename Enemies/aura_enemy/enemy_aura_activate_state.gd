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

var aura_time : float = 4.0


func enter() -> void:
	entity.sprite_manager.play(animation_clip)
	aura.activate_aura(aura_time)


func fixed_run(_delta: float) -> void:
	entity.velocity *= dampening

	if get_elapsed_time() >= attack_duration:
		is_complete = true
