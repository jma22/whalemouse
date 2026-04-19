extends Node3D
class_name CoreComponents

@onready var hurt_box : HurtBox = $HurtBox
@onready var invulnerable_component : InvulnerableComponent = $InvulnerableComponent
@onready var knockback_component : KnockbackComponent = $KnockbackComponent
@onready var hitstop : HitStop = $HitStop
@onready var sprite_manager : SpriteManager = $SpriteManager
@onready var health_component : HealthComponent = $HealthComponent
@onready var status_effect_manager : StatusEffectManager = $StatusEffectManager
@onready var bounce_component : BounceComponent = $BounceComponent


func setup(entity : CharacterBody3D) -> void:
	hurt_box.setup(entity)
	knockback_component.setup(entity)
	bounce_component.setup(entity, entity.get_floor())
	sprite_manager.setup(hitstop)
	health_component.setup(ceil(entity.initial_health + GlobalStats.get_enemy_health_flat()), entity)

func reset() -> void:
	# hurt_box.reset()
	# invulnerable_component.reset()
	# knockback_component.reset()
	hitstop.reset()
	sprite_manager.reset()
	health_component.reset()

func link_hud(hud: HUD) -> void:
	## for player only
	health_component.link_player_health(hud)
