extends State

class_name RollState
@export var animation : AnimationClip
@export var fps: float = 4.0

var roll_direction : Vector2 = Vector2.ZERO
# @export var roll_speed: float = 10.0	
@export var dampening : float = 0.9
@export var invulnerability_time : float = 0.2
var bubbler_scene : PackedScene = load("res://VFX/bubbler.tscn")
var explosion : PackedScene = load("res://Enemies/Projectiles/explosion.tscn")
@export var audio_player : AudioStreamPlayer

@export var roll_hitbox : Hitbox

func enter() -> void:
	# player.sprite_manager.frames_per_second = fps
	entity.sprite_manager.play(animation)
	initial_velocity()
	var bubbler_instance : Node = bubbler_scene.instantiate()
	entity.add_child(bubbler_instance)
	bubbler_instance.start()
	entity.set_invulnerable(true, invulnerability_time)
	audio_player.pitch_scale = 1.0 + randf() * 0.4
	audio_player.play()
	
	if GlobalStats.has_dash_bomb():
		var bomb_instance : Node3D = explosion.instantiate()
		entity.get_parent().add_child(bomb_instance)
		bomb_instance.global_transform.origin = entity.global_transform.origin
		bomb_instance.setup(2.0)
	if GlobalStats.get_dash_damage() > 0:
		roll_hitbox.set_damage(GlobalStats.get_dash_damage())
		roll_hitbox.set_behavior(RollHitboxBehavior.make())
		roll_hitbox.set_active(true)
	

# func run(_delta: float) -> void:
# 	if invulnerability_time <= get_elapsed_time():
# 		entity.set_invulnerable(false)

func exit() -> void:
	# entity.set_invulnerable(false)
	roll_hitbox.set_active(false)

func fixed_run(_delta: float) -> void:
	entity.velocity *= dampening
	if entity.velocity.length() < 1.0:
		is_complete = true

func set_direction(direction: Vector2) -> void:
	roll_direction = direction

func initial_velocity() -> void:
	entity.velocity.x = roll_direction.x * GlobalStats.get_dash_distance()
	entity.velocity.z = roll_direction.y * GlobalStats.get_dash_distance()
