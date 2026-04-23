class_name InfestedEffect extends EnemyStatusEffect

const COLOR : Color = Color(0.45, 0.7, 0.3)
const MINION_TYPE : String = "SquidMinion"

static func make() -> InfestedEffect:
	var effect : InfestedEffect = InfestedEffect.new()
	effect.name = StatusEffectNames.INFESTED
	effect.persists_forever = true
	effect.is_conditional = false
	return effect


func on_entity_died(entity: Node3D) -> void:
	if not entity:
		return
	var parent : Node = entity.get_parent()
	print("infested on_entity_died: ", parent)
	if parent is EnemySpawner:
		(parent as EnemySpawner).spawn_enemy(MINION_TYPE, entity.global_transform.origin)

func get_color_overlay() -> Color:
	return COLOR
