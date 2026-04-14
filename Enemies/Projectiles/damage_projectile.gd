# bullet.gd
extends Node3D

var speed: float = 1.5
var direction: Vector3 = Vector3.ZERO
var lifetime: float = 3.0
@export var hitbox : Hitbox

func setup(direction_: Vector3) -> void:
	self.direction = direction_
	hitbox.set_active(true)
	# cleanup timer
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:

	global_position += direction * speed * delta
	
func on_hitbox_hit() -> void:
	queue_free()
