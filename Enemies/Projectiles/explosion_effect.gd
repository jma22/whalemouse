extends Node3D

@export var animation_player: AnimationPlayer

func play() -> void:
	animation_player.play("explosion")