extends Node3D

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

# var attracted_speed : float = 1.0
var pickup_speed : float = 3.0

var friction : float = 0.8
var velocity : Vector3 = Vector3.ZERO
var gravity : Vector3 = Vector3.DOWN * 4.0
var ground_y : float = 0.0

func _process(delta: float) -> void:
	check_state()

func setup(_velocity : Vector3, _target : Node3D) -> void:
	self.velocity = _velocity
	self.target = _target
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
			print("Launching velocity: ", velocity.length())
			if velocity.length() < 1.0:
				state = PickupState.Idle	
				velocity = Vector3.ZERO
		PickupState.PickedUp:
			if target: 
				var direction = (target.global_transform.origin - global_transform.origin).normalized()
				global_transform.origin += direction * delta * pickup_speed
		PickupState.Attracted:
			if target:
				var direction = (target.global_transform.origin - global_transform.origin).normalized()
				global_transform.origin += direction * delta * GlobalStats.get_attracted_speed()
		PickupState.Despawn:
			if target and target.has_method("on_gain_time"):
				target.on_gain_time(1)
			visible = false
			set_process(false)
			set_physics_process(false)


func check_state() -> void:
	if state == PickupState.Despawn || state ==PickupState.Launching:
		return

	if target:
		var distance_to_target = global_transform.origin.distance_to(target.global_transform.origin)
		if distance_to_target <= despawn_radius:
			state = PickupState.Despawn
		elif distance_to_target <= pickup_radius:
			state = PickupState.PickedUp
		elif distance_to_target <= GlobalStats.get_attracted_radius():
			state = PickupState.Attracted
		else:
			state = PickupState.Idle