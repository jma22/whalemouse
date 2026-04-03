extends State

class_name AttackState
@export var animation : AnimationClip
@export var fps: float = 4.0

var attack_direction : Vector2 = Vector2.ZERO
@export var attack_speed: float = 10.0	
@export var dampening : float = 0.7
@export var jump_strength : float = 4.0
@export var fall_speed : float = -4.0
# @export var invulnerability_time : float = 0.5
@export var hitbox : Hitbox

var hitbox_frame : int = 4
var bubbler_scene : PackedScene = load("res://stomp_bubbler.tscn")
var crack_scene : PackedScene = load("res://Player/crack.tscn")


func enter() -> void:
	# entity.sprite_manager.frames_per_second = fps
	entity.sprite_manager.play(animation, false)
	initial_velocity()
	# entity.set_invulnerable(true)
	# hitbox.set_active(true)

func run(delta: float) -> void:
	if entity.sprite_manager.check_is_done():
		is_complete = true
	

func exit() -> void:
	entity.sprite_manager.frames_per_second = 12
	hitbox.set_active(false)

func fixed_run(_delta: float) -> void:
	if entity.sprite_manager.current_idx == hitbox_frame -2 :
		entity.velocity.y = fall_speed
		var bubbler_instance = bubbler_scene.instantiate()
		entity.get_parent().add_child(bubbler_instance)
		bubbler_instance.global_transform.origin = entity.global_transform.origin + Vector3(0, -0.1, 0)
		bubbler_instance.start()

	if entity.sprite_manager.current_idx == hitbox_frame and not hitbox.is_active:
		hitbox.set_active(true)
		var crack_instance = crack_scene.instantiate() as Sprite3D
		
		entity.get_parent().add_child(crack_instance)
		crack_instance.global_transform = entity.global_transform
		crack_instance.global_transform.origin.y = 0.01
		crack_instance.play()
		


		

	# if hitbox_frame / entity.sprite_manager.frames_per_second > get_elapsed_time():
	# 	hitbox.set_active(true)
	# if (hitbox_frame + 1) / entity.sprite_manager.frames_per_second > get_elapsed_time():
	# 	hitbox.set_active(false)

	
	entity.velocity.x *= dampening
	entity.velocity.z *= dampening
	entity.velocity.y *= dampening*1.2
	if entity.velocity.y < 0 and abs(entity.position.y) < 0.1:
		entity.position.y = 0
		entity.velocity.y = 0
	# 	is_complete = true

func set_direction(direction: Vector2) -> void:
	attack_direction = direction

func initial_velocity() -> void:
	entity.velocity.x = attack_direction.x * attack_speed
	entity.velocity.z = attack_direction.y * attack_speed
	entity.velocity.y = jump_strength
