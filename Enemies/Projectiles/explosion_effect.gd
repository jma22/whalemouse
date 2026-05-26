extends Node3D

class_name ExplosionEffect
@export var animation_player: AnimationPlayer
@export var is_mini_explosion : bool = false
@export var particle_scale : float = 2.5

func _ready() -> void:
	$Flash.process_material.scale_max = particle_scale
	$Flash.process_material.scale_min = particle_scale
	$Sparks.process_material.scale_max = particle_scale
	$Sparks.process_material.scale_min = particle_scale
	$shockwave.process_material.scale_max = particle_scale
	$shockwave.process_material.scale_min = particle_scale
	$floor_shockwave.process_material.scale_max = particle_scale
	$floor_shockwave.process_material.scale_min = particle_scale


func play() -> void:
	if is_mini_explosion:
		animation_player.play("mini_explosion")
	else:
		animation_player.play("explosion")

func wait_for_animation_done() -> void:
	await animation_player.animation_finished