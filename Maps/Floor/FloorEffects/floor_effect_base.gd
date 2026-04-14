class_name FloorEffectBase extends Area3D

enum FloorEffectTarget {
	PLAYER,
	ENEMY
}
var lifetime : float = 440.0
var time_active : float = 0.0
@export var target : FloorEffectTarget = FloorEffectTarget.PLAYER

func _ready() -> void:
	monitorable = true
	# connect("body_entered", Callable(self, "_on_enter"))
	# connect("body_exited", Callable(self, "_on_exit"))
	# self.set_deferred("monitorable", true)
	


func _process(delta: float) -> void:
	time_active += delta
	if time_active >= lifetime:
		queue_free()


func _on_enter() -> void:
	print("entered floor effect area")

func _on_exit() -> void:
	print("exited floor effect area")



func set_collisions() -> void:
	match target:
		FloorEffectTarget.PLAYER:
			collision_layer = 1
			# collision_mask = 1
		FloorEffectTarget.ENEMY:
			collision_layer = 2
			# collision_mask = 2
