class_name HurtBox extends Area3D

@export var hurt_box_type: HurtBoxType = HurtBoxType.PLAYER
@export var hit_sound_fx : AudioStream
@export var hit_sound : AudioStreamPlayer
@export var time_on_hit : Node3D

@export var orbs_on_hit : int = 0
@export var ebb_on_hit : int = 0

var owner_entity: CharacterBody3D
var is_active : bool = true

enum HurtBoxType {
	PLAYER,
	ENEMY
}

func setup(owner_entity_: CharacterBody3D) -> void:
	owner_entity = owner_entity_

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	set_collisions()
	hit_sound.stream = hit_sound_fx


func _on_area_entered(area: Area3D) -> void:
	if not is_active:
		return
	if area is Hitbox:
		owner_entity.on_hit(area)
	elif area is FloorEffectBase:
		area._on_enter(owner_entity)

func _on_area_exited(area: Area3D) -> void:
	if area is FloorEffectBase:
		area._on_exit(owner_entity)

func on_valid_damaging_hit() -> void:
	if orbs_on_hit > 0:
		time_on_hit.spawn_time(orbs_on_hit)
	if ebb_on_hit > 0:
		time_on_hit.spawn_ebb(ebb_on_hit)
	if hit_sound:
		hit_sound.pitch_scale = 0.75 + randf() * 0.5
		hit_sound.play()


func set_collisions() -> void:
	match hurt_box_type:
		HurtBoxType.PLAYER:
			# collision_layer = 1
			collision_mask = 1
		HurtBoxType.ENEMY:
			# collision_layer = 2
			collision_mask = 2
			

func set_active(active: bool) -> void:
	self.set_deferred("monitoring", active)
	## show visible
	# if sprite3D:
	# 	sprite3D.visible = active
	is_active = active

func activate_hitbox() -> void:
	set_active(true)

func deactivate_hitbox() -> void:
	set_active(false)
