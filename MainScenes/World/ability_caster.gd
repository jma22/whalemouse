extends Node3D
class_name AbilityCaster

static var ABILITY_CLASSES : Dictionary = {
	"beluga_ability": WhaleAbility,
	"homing_ability": HomingAbility,
	"grappling_ability": GrapplingAbility,
}
static var instance : AbilityCaster

var player : CharacterBody3D
var camera : Camera3D
var map : MapManagerBase
var current_ability : Ability = null
var base_cooldown : float = 5.0
var cooldown_timer : float = 0.0



func _ready() -> void:
	instance = self
	GlobalStats.ability_equipped.connect(_on_ability_equipped)

func _on_ability_equipped(ability_name : String) -> void:
	if ABILITY_CLASSES.has(ability_name):
		current_ability = ABILITY_CLASSES[ability_name].new()
		add_child(current_ability)
		current_ability.setup(player, camera)
		current_ability.enter_map(map)
		DebugLog.dbg_from(self,"Equipped ability: %s" % ability_name)

func setup(player_ : CharacterBody3D, camera_ : Camera3D) -> void:
	self.player = player_
	self.camera = camera_
	if current_ability != null:
		current_ability.setup(player_, camera_)

func enter_map(map : MapManagerBase) -> void:
	self.map = map
	DebugLog.dbg_from(self,"Entered map: %s" % map.name)
	# self.enemy_spawner = map.enemy_spawner
	if current_ability != null:
		current_ability.enter_map(map)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spawn_whale"):
		if can_cast():	
			cooldown_timer = current_ability.get_cooldown()
			current_ability.cast()

func _process(delta: float) -> void:
	if cooldown_timer > 0.0:
		cooldown_timer -= delta
		if cooldown_timer < 0.0:
			cooldown_timer = 0.0
	# if StatCalculator.beluga_auto_cast() and can_cast():
	# 	DebugLog.dbg_from(self,"auto-casting whale because of beluga_auto_cast")
	# 	# if not (player as Player).status_effect_manager.has_status_effect(StatusEffectNames.FREEZE):
	# 	current_ability.cast()


func can_cast() -> bool:
	return current_ability != null and cooldown_timer <= 0.0


func get_cooldown_progress() -> float:
	return 1.0 - (cooldown_timer / current_ability.get_cooldown())

	
func refund_ability_cooldown(percentage : float) -> void:
	cooldown_timer = max(cooldown_timer * 1.0 - percentage * current_ability.get_cooldown(), 0.0)
	DebugLog.dbg_from(self,"refund_cooldown by %.1f%% → cooldown_timer: %.1fs" % [percentage*100.0, cooldown_timer])

func has_ability() -> bool:
	return current_ability != null
