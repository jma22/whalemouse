class_name PoisonEffect extends EnemyStatusEffect

const MAX_STACKS : int = 5
const EXPIRY_DAMAGE : int = 1
const COLOR_MIN : Color = Color(0.75, 1, 0.75)
const COLOR_MAX : Color = Color(0.25, 0.9, 0.25)
const TICK_DURATION : float = 3.0

static func make() -> PoisonEffect:
	var effect : PoisonEffect = PoisonEffect.new()
	effect.name = StatusEffectNames.POISON
	var tick_duration : float = TICK_DURATION * StatCalculator.get_poison_tick_multiplier()
	effect.time_remaining = tick_duration
	effect.duration = tick_duration
	effect.is_conditional = false
	effect.max_stacks = MAX_STACKS
	effect.stacks = 1
	return effect


func _stack_with(existing: StatusEffectBase) -> void:
	existing.stacks = min(existing.stacks + 1, MAX_STACKS)
	existing.time_remaining = min(time_remaining, existing.time_remaining)

func _on_expired(entity: Node3D) -> bool:
	var expiry_damage : int = StatCalculator.get_poison_expiry_damage()
	if entity and "health_component" in entity:
		entity.health_component.take_damage(expiry_damage)
		_dbg("expiry dealt %s dmg to %s (stacks remaining=%s)" % [expiry_damage, DebugLog.entity_name(entity), stacks - 1])
		if "sprite_manager" in entity and entity.sprite_manager:
			entity.sprite_manager.damage_flash()
		if "hurt_box" in entity and entity.hurt_box and entity.hurt_box.hit_sound:
			entity.hurt_box.hit_sound.pitch_scale = 0.75 + randf() * 0.5
			entity.hurt_box.hit_sound.play()
	stacks -= 1
	if stacks > 0:
		time_remaining = duration
		return false
	return true

func _on_killed_by_effect(entity: Node3D) -> void:
	var orb_count : int = StatCalculator.get_poison_kills_drop_orbs()
	if orb_count > 0:
		_dbg("poison kill → spawning %s time orbs at %s" % [orb_count, DebugLog.entity_name(entity)])
		_spawn_orbs(entity, orb_count, CollectibleSpawner.OrbType.TIME)

func _on_entity_died(entity: Node3D) -> void:
	if StatCalculator.has_poison_enemies_drop_bombs():
		var explosion : PackedScene = load("res://Enemies/Projectiles/Explosion.tscn")
		var explosion_instance : Node3D = explosion.instantiate()
		entity.get_parent().add_child(explosion_instance)
		explosion_instance.global_transform.origin = entity.global_transform.origin
		explosion_instance.global_transform.origin.y = 0.0
		explosion_instance.setup(null)
		_dbg("poisoned_drop_bombs → spawned explosion at %s" % DebugLog.entity_name(entity))
	var ebb_count : int = StatCalculator.get_poisoned_enemies_drop_ebbs()
	if ebb_count > 0:
		_dbg("poisoned_drop_ebbs → spawned %s ebb orbs at %s" % [ebb_count, DebugLog.entity_name(entity)])
		_spawn_orbs(entity, ebb_count, CollectibleSpawner.OrbType.EBB)

func _spawn_orbs(entity: Node3D, count: int, orb_type: CollectibleSpawner.OrbType) -> void:
	var xp_spawner_scene : PackedScene = load("res://Collectibles/xp_spawner.tscn")
	var xp_spawner : Node3D = xp_spawner_scene.instantiate()
	entity.get_parent().add_child(xp_spawner)
	xp_spawner.global_transform.origin = entity.global_transform.origin
	xp_spawner.setup_outwards(count, GlobalStats.player, orb_type, GlobalStats.player.get_floor())

func get_color_overlay() -> Color:
	var t : float = float(stacks - 1) / float(max(max_stacks - 1, 1))
	return COLOR_MIN.lerp(COLOR_MAX, clamp(t, 0.0, 1.0))
