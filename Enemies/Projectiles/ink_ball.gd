extends Node3D

@export var ink_ball : Node3D
@export var indicator : Node3D
@export var hitbox : Hitbox

var hitbox_active_time : float = 0.1
var hitbox_timer : float = 0.0
func _ready() -> void:
	hitbox_timer = 0.0
	hitbox.set_active(false)
	setup(Vector3.ZERO)

func setup(target_position : Vector3) -> void:
	# look_at(target_position, Vector3.UP)
	# indicator.look_at(target_entity.global_transform.origin, Vector3.UP)
	indicator.global_transform.origin = target_position
	ink_ball.get_node("PhysicsManager").setup(target_position)
	indicator.visible = true
	ink_ball.visible = true

func _process(delta: float) -> void:
	if hitbox.is_active:
		hitbox_timer += delta
		if hitbox_timer >= hitbox_active_time:
			hitbox.set_active(false)
			despawn()

func on_contact_floor():
	indicator.visible = false
	ink_ball.visible = false
	hitbox.set_active(true)


func despawn() -> void:
	queue_free()
