extends Node3D

@export var scene_container : Node3D

func _ready() -> void:
	SceneManager.setup(scene_container)
