extends State

class_name EnemyJumpAttackState
var target_position : Vector3
@export var animation_clip : AnimationClip


var time : float = 0.8
var horizontal_dist : float = 1.0
var max_height : float = 0.6
var hang_time : float = 0.1
var sharpness : float = 0.7
var descent_mult : float = 0.2

var max_x_distance : float = 1.0
# var threshold : float = 0.05
# var gravity : float = 9.8

var _arc_velocity : float = 0.0
var _current_arc_pos : float = 0.0
var lateral_velocity : Vector3 = Vector3.ZERO
var TILT_DEGREES : float = 30


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
	_current_arc_pos = 0.0


func exit() -> void:
	entity.hitbox.set_active(false)
	entity.knockback_component.set_knockbackable(true)

func run(_delta: float) -> void:
	check_state()

func fixed_run(_delta: float) -> void:
	var arc_axis := Vector3(0, cos(deg_to_rad(TILT_DEGREES)), -sin(deg_to_rad(TILT_DEGREES))).normalized()

	var t = get_elapsed_time() / time
	t = clamp(t, 0, 1)

	var hang_frac = hang_time / time
	var hang_start = 0.5 - hang_frac * 0.5
	var hang_end   = 0.5 + hang_frac * 0.5


	if t >= hang_start and t <= hang_end:
		_arc_velocity = 0.0
	else:

		var arc_t: float
		if t < hang_start:
			arc_t = (t / hang_start) * 0.5
		else:
			arc_t = 0.5 + ((t - hang_end) / (1.0 - hang_end)) * 0.5

		var shaped_t: float
		if arc_t <= 0.5:
			shaped_t = pow(arc_t * 2.0, sharpness) * 0.5
		else:
			shaped_t = 0.5 + pow((arc_t - 0.5) * 2.0, sharpness / descent_mult) * 0.5

		var target_arc_pos  := 4.0 * max_height * shaped_t * (1.0 - shaped_t)

		_arc_velocity = (target_arc_pos - _current_arc_pos) / _delta 

	_current_arc_pos += _arc_velocity * _delta
	entity.velocity = arc_axis * _arc_velocity + lateral_velocity

	# if _arc_velocity < 0 and abs(current_arc_pos) < 0.1:
	if get_elapsed_time() >= time + hang_time:
		_arc_velocity = 0.0
		entity.velocity =  Vector3.ZERO
		is_complete = true

func set_target_position(position: Vector3) -> void:
	target_position = position

func check_state() -> void:
	pass

func apply_velocity()-> void:
	if target_position == null:
		return
	# var t_up = time / 2
	# gravity = (2 * height) / (t_up * t_up)
	# var up_velocity = gravity * t_up

	var direction : Vector3 = (target_position - entity.global_transform.origin)
	# var direction : Vector3 = Vector3.ZERO
	var magnitude : float = direction.length()
	magnitude = min(magnitude, max_x_distance)
	direction = direction.normalized()
	# direction.y = gravity / time 
	lateral_velocity = direction * magnitude / (time + hang_time)
	
