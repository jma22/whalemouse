extends Node3D

class_name ArcComponent

@export var animation_clip: AnimationClip

@export var base_time: float = 1.5
@export var base_max_height: float = 0.7
@export var base_hang_time: float = 0.1
@export var sharpness: float = 1.2
@export var descent_mult: float = 1.0
@export var max_x_distance: float = 4.0
var TILT_DEGREES: float = 90 + Constants.TILT_ANGLE

var arc_axis := Vector3(0, cos(deg_to_rad(TILT_DEGREES)), -sin(deg_to_rad(TILT_DEGREES))).normalized()
var velocity: Vector3 = Vector3.ZERO
var elapsed_time: float = 0.0
var is_finished: bool = false
var multiplier: float = 1.0

var _arc_velocity: float = 0.0
var _current_arc_pos: float = 0.0
var _lateral_velocity: Vector3 = Vector3.ZERO
var _target_position: Vector3 = Vector3.ZERO

func setup(target: Vector3) -> void:
    _target_position = target
    _current_arc_pos = 0.0
    _arc_velocity = 0.0
    elapsed_time = 0.0
    is_finished = false
    velocity = Vector3.ZERO
    _set_lateral_velocity()

func tick(delta: float) -> void:
    if is_finished:
        return
    _set_velocity(delta)
    elapsed_time += delta
    if elapsed_time >= get_time() + get_hang_time():
        _arc_velocity = 0.0
        _lateral_velocity = Vector3.ZERO
        velocity = Vector3.ZERO
        is_finished = true

func _set_velocity(delta: float) -> void:
    var t : float = clamp(elapsed_time / get_time(), 0.0, 1.0)

    var hang_frac := get_hang_time() / get_time()
    var hang_start := 0.5 - hang_frac * 0.5
    var hang_end   := 0.5 + hang_frac * 0.5

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

        var target_arc_pos := 4.0 * get_height() * shaped_t * (1.0 - shaped_t)
        _arc_velocity = (target_arc_pos - _current_arc_pos) / delta

    _current_arc_pos += _arc_velocity * delta
    velocity = arc_axis * _arc_velocity + _lateral_velocity
    

func _set_lateral_velocity() -> void:
    var direction := (_target_position - global_transform.origin)
    var magnitude := minf(direction.length(), max_x_distance)
    _lateral_velocity = direction.normalized() * magnitude / (get_time() + get_hang_time())

func get_time() -> float:
    return base_time * multiplier

func get_hang_time() -> float:
    return base_hang_time * multiplier

func get_height() -> float:
    return base_max_height * multiplier

func set_multiplier(mult: float) -> void:
    multiplier = mult