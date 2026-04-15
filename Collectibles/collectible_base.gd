@abstract class_name CollectibleBase extends Node3D

enum PickupState {
	Idle,
	Launching,
	PickedUp,
	Attracted,
	Despawn
}

var state : PickupState = PickupState.Idle
@export var target : Node3D
# var attracted_radius : float = 2.0
var pickup_radius : float = 0.7
var despawn_radius : float = 0.4
var animation_clip : AnimationClip
@export var sprite_manager : SpriteManager
@export var audio_player : AudioStreamPlayer
# var attracted_speed : float = 1.0
var pickup_speed : float = 3.0
var floor : FloorNav

var friction : float = 0.8
var velocity : Vector3 = Vector3.ZERO
var gravity : Vector3 = Vector3.DOWN * 4.0
var ground_y : float = 0.0

func _process(delta: float) -> void:
	check_state()

func setup(_velocity : Vector3, _target : Node3D, _floor : FloorNav) -> void:
	self.animation_clip = AnimationClip.new()
	self.animation_clip.frame_numbers = [0,1,2]
	if sprite_manager:
		sprite_manager.play(self.animation_clip)

	self.velocity = _velocity
	self.target = _target
	self.floor = _floor
	state = PickupState.Launching

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	## bob up and down in sine
	global_transform.origin.y += sin(Time.get_ticks_msec() / 1000.0 * 2.0) * 0.005
	match state:
		PickupState.Idle:
			pass
		PickupState.Launching:
			position += velocity * delta
			if global_transform.origin.y <= ground_y:
				global_transform.origin.y = ground_y
				velocity.y = 0.0
			else:
				velocity += gravity * delta
			velocity *= friction
			if velocity.length() < 1.0:
				state = PickupState.Idle	
				velocity = Vector3.ZERO
		PickupState.PickedUp:
			if target: 
				var direction : Vector3 = (target.global_transform.origin - global_transform.origin).normalized()
				global_transform.origin += direction * delta * pickup_speed
		PickupState.Attracted:
			if target:
				var direction : Vector3 = (target.global_transform.origin - global_transform.origin).normalized()
				global_transform.origin += direction * delta * GlobalStats.get_attracted_speed()
		PickupState.Despawn:
			visible = false
			set_process(false)
			set_physics_process(false)
	if floor:
		global_transform.origin = floor.clamp_position(global_transform.origin)


func check_state() -> void:
	if state == PickupState.Despawn || state ==PickupState.Launching:
		return

	if target:
		var distance_to_target : float = global_transform.origin.distance_to(target.global_transform.origin)
		if distance_to_target <= despawn_radius:
			state = PickupState.Despawn
			on_pickup()
			play_sound()
		elif distance_to_target <= pickup_radius:
			state = PickupState.PickedUp
		elif distance_to_target <= GlobalStats.get_attracted_radius():
			state = PickupState.Attracted
		else:
			state = PickupState.Idle


func play_sound() -> void:
	if audio_player and audio_player.stream:
		audio_player.pitch_scale = 2.2 + 0.5 * randf()
		audio_player.play()
@abstract
func on_pickup() -> void
