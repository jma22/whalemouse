extends Node

@export var amplitude: float = 0.1
@export var speed: float = 2.0

var base_position: Vector3
var time: float = 0.0
var arc_axis := Vector3(0, cos(deg_to_rad(30)), -sin(deg_to_rad(30))).normalized()

func _ready() -> void:
	base_position = get_parent().position
	time = randf() * TAU

func _process(delta: float) -> void:
	time += delta
	get_parent().position = base_position + arc_axis * sin(time * speed) * amplitude