extends ProjectileBase

@export var ink_ball : Node3D
@export var indicator : Node3D
@export var hitbox : Hitbox
@export var explosion_fx : ExplosionEffect


var hitbox_active_time : float = 0.1
var has_contacted_floor : bool = false
var hitbox_timer : float = 0.0
# var explosion_done : bool = false

func _ready() -> void:
	hitbox_timer = 0.0
	hitbox.damage_type = DamageInfo.DamageType.INK
	hitbox.set_active(false)
	# setup(Vector3.ZERO)

func setup(target_position : Vector3, source_: Node3D) -> void:
	super.set_source(source_)
	hitbox.source = source_
	# look_at(target_position, Vector3.UP)
	# indicator.look_at(target_entity.global_transform.origin, Vector3.UP)
	indicator.global_transform.origin = target_position
	ink_ball.get_node("PhysicsManager").setup(target_position)
	indicator.visible = true
	ink_ball.visible = true

func _process(delta: float) -> void:
	if hitbox.is_active:
		DebugLog.dbg_from(self,"hitbox active for %.2f seconds" % hitbox_timer)
		hitbox_timer += delta
		if hitbox_timer >= hitbox_active_time:
			DebugLog.dbg_from(self,"hitbox active time expired, deactivating hitbox")
			hitbox.set_active(false)

func on_contact_floor() -> void:
	if has_contacted_floor:
		return
	has_contacted_floor = true
	indicator.get_node("IndicatorSprite").visible = false

	ink_ball.visible = false
	hitbox.set_active(true)
	explosion_fx.play()
	await explosion_fx.wait_for_animation_done()
	despawn()


func despawn() -> void:
	queue_free()
