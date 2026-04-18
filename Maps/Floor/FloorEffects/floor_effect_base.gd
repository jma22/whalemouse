@abstract
class_name FloorEffectBase extends Area3D

enum FloorEffectTarget {
	PLAYER,
	ENEMY
}
var lifetime : float = 440.0
var time_active : float = 0.0
@export var target : FloorEffectTarget = FloorEffectTarget.PLAYER
@export var sprite_manger : SpriteManager

func _ready() -> void:
	deactivate_aura()
	set_collisions()
	


func _process(delta: float) -> void:
	time_active += delta
	if time_active >= lifetime:
		deactivate_aura()
		# queue_free()

@abstract
func _on_enter(entity : CharacterBody3D) -> void

@abstract
func _on_exit(entity : CharacterBody3D) -> void


func activate_aura(time : float) -> void:
	self.set_deferred("monitorable", true)
	time_active = 0.0
	lifetime = time
	if sprite_manger:
		sprite_manger.show()

func deactivate_aura() -> void:
	self.set_deferred("monitorable", false)
	if sprite_manger:
		sprite_manger.hide()


func set_collisions() -> void:
	match target:
		FloorEffectTarget.PLAYER:
			collision_layer = 1
			# collision_mask = 1
		FloorEffectTarget.ENEMY:
			collision_layer = 2
			# collision_mask = 2
