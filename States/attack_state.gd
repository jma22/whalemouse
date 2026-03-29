extends State

class_name AttackState
@export var animation : AnimationClip
@export var fps: float = 4.0

var attack_direction : Vector2 = Vector2.ZERO
@export var attack_speed: float = 10.0	
@export var dampening : float = 0.7
# @export var invulnerability_time : float = 0.5
@export var hitbox : Hitbox
var hitbox_frame : int = 1


func enter() -> void:
	# player.sprite_manager.frames_per_second = fps
	entity.sprite_manager.play(animation)
	initial_velocity()
	# entity.set_invulnerable(true)
	hitbox.set_active(true)

# func run(delta: float) -> void:
	

func exit() -> void:
	hitbox.set_active(false)

func fixed_run(_delta: float) -> void:
	# if hitbox_frame / entity.sprite_manager.frames_per_second > get_elapsed_time():
	# 	hitbox.set_active(true)
	# if (hitbox_frame + 1) / entity.sprite_manager.frames_per_second > get_elapsed_time():
	# 	hitbox.set_active(false)

	
	entity.velocity *= dampening
	if entity.velocity.length() < 0.5:
		is_complete = true

func set_direction(direction: Vector2) -> void:
	attack_direction = direction

func initial_velocity() -> void:
	entity.velocity.x = attack_direction.x * attack_speed
	entity.velocity.z = attack_direction.y * attack_speed