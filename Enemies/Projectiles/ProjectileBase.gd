class_name ProjectileBase
extends Node3D

var source : Node3D
var owner_entity : Node3D

func set_source(source_ : Node3D ,) -> void:
	print("setting projectile source to ", source_)
	source = source_
