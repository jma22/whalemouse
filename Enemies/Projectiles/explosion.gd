extends Node3D

@export var bomb_sprite : SpriteManager
@export var explosion_sprite : SpriteManager
@export var explosion_area : SpriteManager

@export var explosion_hitbox : Hitbox
@export var enemy_hitbox : Hitbox


func _ready() -> void:
	bomb_sprite.setup(null)
	explosion_sprite.setup(null)
	explosion_area.setup(null)
	setup(1.5)


func setup(time_to_explode: float) -> void:
	bomb_sprite.visible = true
	explosion_sprite.visible = false
	explosion_area.visible = true
	bomb_sprite.set_charge_color(0)
	explosion_area.set_charge_color(0)
	explosion_sprite.set_flash_level(1)

	var tween := create_tween()

	# charge up (parallel)
	tween.tween_property(bomb_sprite, "material_overlay:shader_parameter/charge_level", 1.0, time_to_explode)
	tween.parallel().tween_property(explosion_area, "material_overlay:shader_parameter/charge_level", 1.0, time_to_explode)

	# explode
	tween.tween_callback(explosion_hitbox.set_active.bind(true))
	tween.tween_callback(enemy_hitbox.set_active.bind(true))
	tween.tween_callback(explosion_sprite.show)
	tween.tween_callback(bomb_sprite.hide)
	tween.tween_callback(explosion_area.set_flash_level.bind(1))
	tween.tween_interval(0.1)
	tween.tween_callback(explosion_hitbox.set_active.bind(false))
	tween.tween_callback(enemy_hitbox.set_active.bind(false))

	# fade out (parallel)
	tween.tween_property(explosion_sprite, "modulate:a", 0.0, 0.4)
	tween.parallel().tween_property(explosion_area, "modulate:a", 0.0, 0.4)

	# cleanup
	tween.tween_callback(queue_free)
