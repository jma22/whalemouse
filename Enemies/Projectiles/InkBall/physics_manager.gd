extends Node3D

var target_position : Vector3
@export var animation_clip : AnimationClip

var elapsed_time : float = 0
@onready var parent : Node3D = get_parent() as Node3D
@export var root : Node3D
@export var arc_component : ArcComponent


# @export var audio_player : AudioStreamPlayer
var bubbler_scene : PackedScene = load("res://VFX/bubbler.tscn")

func setup(target_position: Vector3) -> void:
	arc_component.setup(target_position)
	arc_component.set_multiplier(1 / StatCalculator.get_enemy_attack_speed_multiplier())


func _physics_process(delta: float) -> void:
	if parent == null:
		return
	arc_component.tick(delta)
	parent.global_position += arc_component.velocity * delta

	if arc_component.is_finished:
		root.on_contact_floor()
	
