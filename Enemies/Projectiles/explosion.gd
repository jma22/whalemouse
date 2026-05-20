extends ProjectileBase
class_name BombExplosion

@export var bomb_sprite : SpriteManager
@export var explosion_sprite : SpriteManager
@export var explosion_area : SpriteManager

@export var explosion_hitbox : Hitbox
@export var enemy_hitbox : Hitbox

@export var xp_spawner_scene : PackedScene 

var time_to_explode : float = 2.0
var is_super_bomb : bool = false

const BASE_BOMB_DAMAGE : int = 2
const BASE_BOMB_FRIENDLY_FIRE_DAMAGE : int = 5

var drop_animation : AnimationClip = AnimationClip.new()
var charging_animation : AnimationClip = AnimationClip.new()

func _ready() -> void:
	bomb_sprite.setup(null)
	explosion_sprite.setup(null)
	explosion_area.setup(null)
	drop_animation.frame_numbers = [3,4,5,6]
	charging_animation.frame_numbers = [0,1,2]

	explosion_hitbox.damage_type = DamageInfo.DamageType.BOMB
	enemy_hitbox.damage_type = DamageInfo.DamageType.BOMB
	
	time_to_explode = StatCalculator.get_bomb_tick_time()
	
	scale = Vector3.ONE * StatCalculator.get_bomb_size()
	
		# explosion_hitbox.damage_type = DamageInfo.DamageType.SUPER_BOMB
		# explosion_sprite.set_flash_level(2)






func setup(source : Node3D) -> void:
	super.set_source(source)
	explosion_hitbox.source = source
	enemy_hitbox.source = source
	is_super_bomb = randf() < StatCalculator.get_super_bomb_chance()
	if is_super_bomb:
		# explosion_sprite.modulate = Color(1, 0.0, 0.5)
		explosion_area.modulate = Color(1, 0.0, 0.5)
		DebugLog.dbg_from(self,"super_bomb rolled (chance=%.2f) → doubled dmg" % StatCalculator.get_super_bomb_chance())
	explosion_hitbox.damage = BASE_BOMB_DAMAGE * (2 if is_super_bomb else 1)
	enemy_hitbox.damage = BASE_BOMB_FRIENDLY_FIRE_DAMAGE * (2 if is_super_bomb else 1)


	enemy_hitbox.set_behavior(ExplosionHitboxBehavior.make(is_super_bomb))
	explosion_hitbox.set_behavior(ExplosionHitboxBehavior.make(is_super_bomb))
	bomb_sprite.visible = true
	# explosion_sprite.visible = false
	explosion_area.visible = true
	bomb_sprite.set_charge_color(0)
	explosion_area.set_charge_color(0)
	# explosion_sprite.set_flash_level(1)


	# charge up (parallel)
	bomb_sprite.play(drop_animation, false)
	while not bomb_sprite.check_is_done():
		await get_tree().process_frame
	bomb_sprite.play(charging_animation, true)
	var tween := create_tween()

	DebugLog.dbg_from(self,"Bomb planted, will explode in %.2f seconds" % time_to_explode)
	tween.tween_property(bomb_sprite, "material_overlay:shader_parameter/charge_level", 1.0, time_to_explode)
	tween.parallel().tween_property(explosion_area, "material_overlay:shader_parameter/charge_level", 1.0, time_to_explode)

	# explode
	tween.tween_callback(explosion_hitbox.set_active.bind(true))
	tween.tween_callback(enemy_hitbox.set_active.bind(true))
	tween.tween_callback(explosion_sprite.play)
	# tween.tween_callback(explosion_sprite.show)
	tween.tween_callback(bomb_sprite.hide)
	tween.tween_callback(explosion_area.set_flash_level.bind(1))
	tween.tween_interval(0.1)
	tween.tween_callback(explosion_hitbox.set_active.bind(false))
	tween.tween_callback(enemy_hitbox.set_active.bind(false))

	# fade out (parallel)
	# tween.tween_property(explosion_sprite, "modulate:a", 0.0, 0.4)
	tween.parallel().tween_property(explosion_area, "modulate:a", 0.0, 0.4)
	tween.tween_callback(maybe_orb_drop)
	# cleanup
	tween.tween_callback(queue_free)


func maybe_orb_drop() -> void:
	if GlobalStats.player.map_ref is ShrineMapManager:
		return	
	var chance : float = 0.5
	var num_orbs : int = 0
	var num_ebbs : int = 0
	for i in range(StatCalculator.get_lucky_bomb_roll_times()):
		if randf() < chance:
			num_orbs += 1
		if randf() < chance:
			num_ebbs += 1
	if num_orbs > 0 or num_ebbs > 0:
		var xp_spawner : Node3D = xp_spawner_scene.instantiate()
		get_parent().add_child(xp_spawner)

		xp_spawner.global_transform.origin = global_transform.origin
		if num_orbs > 0:
			xp_spawner.setup_outwards(num_orbs, GlobalStats.player, CollectibleSpawner.OrbType.TIME, GlobalStats.player.get_floor())
			DebugLog.dbg_from(self,"bomb_orb_drop → spawned %d time orbs" % num_orbs)
		if num_ebbs > 0:
			xp_spawner.setup_outwards(num_ebbs, GlobalStats.player, CollectibleSpawner.OrbType.EBB, GlobalStats.player.get_floor())
			DebugLog.dbg_from(self,"bomb_orb_drop → spawned %d ebb orbs" % num_ebbs)
		
