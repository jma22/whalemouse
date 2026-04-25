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
@onready var shield_component : ShieldComponent = $ShieldComponent
@onready var enemy_status_display : EnemyStatusDisplay = $EnemyStatusDisplay

func setup(entity : CharacterBody3D) -> void:
	hurt_box.setup(entity)
	knockback_component.setup(entity)
	bounce_component.setup(entity)
	sprite_manager.setup(hitstop)
	health_component.setup(entity.get_initial_health(), entity)
	status_effect_manager.setup(entity)
	shield_component.setup(entity)
	enemy_status_display.setup(status_effect_manager, sprite_manager)

func reset() -> void:
	# hurt_box.reset()
	# invulnerable_component.reset()
	# knockback_component.reset()
	hitstop.reset()
	sprite_manager.reset()
	health_component.reset()
	enemy_status_display.reset()

func link_hud(hud: HUD) -> void:
	## for player only
	health_component.link_player_health(hud)
