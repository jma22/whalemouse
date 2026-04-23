class_name EbbyEffect extends EnemyStatusEffect

const COLOR : Color = Color(0.45, 0.5, 0.9)
const NUM_EBB_ORBS : int = 1

static func make() -> InfestedEffect:
	var effect : InfestedEffect = InfestedEffect.new()
	effect.name = StatusEffectNames.INFESTED
	effect.persists_forever = true
	effect.is_conditional = false
	return effect


func  on_entity_died(entity: Node3D) -> void:
	if not entity:
		return
	var xp_spawner_instance : Node = entity.xp_spawner_scene.instance()
	entity.get_parent().add_child(xp_spawner_instance)
	xp_spawner_instance.global_transform.origin = entity.global_transform.origin
	xp_spawner_instance.global_transform.origin.y = 0.0
	xp_spawner_instance.setup_outwards(NUM_EBB_ORBS, entity.player, CollectibleSpawner.OrbType.EBB, entity.get_floor())

func get_color_overlay() -> Color:
	return COLOR
