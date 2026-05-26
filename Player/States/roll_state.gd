extends State

class_name RollState
@export var animation : AnimationClip
@export var fps: float = 4.0

var roll_direction : Vector2 = Vector2.ZERO
# @export var roll_speed: float = 10.0	
@export var dampening : float = 0.9
@export var invulnerability_time : float = 0.2
@export var bubbler_scene : PackedScene 
@export var explosion : PackedScene 
@export var audio_player : AudioStreamPlayer

@export var roll_hitbox : Hitbox

const BASE_DASH_DISTANCE : float = 9.0

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
	roll_hitbox.set_behavior(RollHitboxBehavior.make())
	

	
	if StatCalculator.has_suicide_dash():
		entity.damage(1)
		entity.sprite_manager.damage_flash()
		DebugLog.dbg_from(self,"suicide_dash → player took 1 dmg")

	if StatCalculator.dash_damages_status() or StatCalculator.has_marking_dash() or StatCalculator.get_midas_dash_touch_num() > 0:
		roll_hitbox.set_active(true)
		DebugLog.dbg_from(self,"roll hitbox active (dash_damages_status=%s marking_dash=%s)" % [
			StatCalculator.dash_damages_status(), StatCalculator.has_marking_dash()
		])

	if StatCalculator.has_dash_bomb():
		var bomb_instance : Node3D = explosion.instantiate()
		entity.get_parent().add_child(bomb_instance)
		bomb_instance.global_transform.origin = entity.global_transform.origin
		bomb_instance.setup(entity)
		DebugLog.dbg_from(self,"dash_bomb → spawned explosion at player")
	# if StatCalculator.get_dash_damage() > 0:
	# 	roll_hitbox.set_active(true)
	

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
	entity.velocity.x = roll_direction.x * BASE_DASH_DISTANCE * StatCalculator.get_dash_distance_decrease()
	entity.velocity.z = roll_direction.y * BASE_DASH_DISTANCE * StatCalculator.get_dash_distance_decrease() * Constants.VERTICAL_PERSRPECTIVE_SCALE
