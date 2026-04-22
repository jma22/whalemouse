extends FloorEffectBase

var effect : PlayerStatusEffect = PlayerStatusEffect.create_conditional("haste")
func _on_enter(entity : CharacterBody3D) -> void:
	if target == FloorEffectTarget.PLAYER and entity is Player:
		var player : Player = entity as Player
		player.status_effect_manager.gain_status_effect(effect, self)

func _on_exit(entity : CharacterBody3D) -> void:
	if target == FloorEffectTarget.PLAYER and entity is Player:
		var player : Player = entity as Player
		player.status_effect_manager.lose_status_effect(effect, self)
