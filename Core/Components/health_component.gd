extends Node
class_name HealthComponent

var hp_display: HPDisplay
var max_health: int
var current_health: int
var entity : CharacterBody3D
var is_player : bool = false

var ebb_effect : SlowEffect = SlowEffect.make_conditional()

func setup(_max_health: int, entity: CharacterBody3D) -> void:
	self.max_health = _max_health
	self.entity = entity
	current_health = max_health
	is_player = entity is Player
	DebugLog.dbg_from(self,"HealthComponent setup with max_health=%s for entity %s (is_player=%s)" % [max_health, DebugLog.entity_name(entity), is_player])

func link_player_health(hud: HUD) -> void:
	self.hp_display = hud.hp_display
	self.hp_display.refresh_hp(current_health)

	
func reset() -> void:
	current_health = max_health
	if hp_display:  
		hp_display.refresh_hp(current_health)


func take_damage(damage: int) -> void:
	current_health -= damage
	if StatCalculator.get_dying_ebb() >= current_health and entity is Player:
		DebugLog.dbg_from(self,"dying_ebb threshold reached (threshold=%s hp=%s) → gained Slow" % [StatCalculator.get_dying_ebb(), current_health])
		entity.gain_status_effect(ebb_effect, self)

	if current_health <= 0:
		current_health = 0
	if hp_display:
		hp_display.lose_hp(damage, current_health)

func gain_health(amount: int) -> void:
	current_health += amount
	if StatCalculator.get_dying_ebb() < current_health and entity is Player:
		entity.lose_status_effect(ebb_effect, self)
	if current_health > get_functional_max_health():
		current_health = get_functional_max_health()
	if hp_display:
		hp_display.gain_hp(amount, current_health)

func set_max_health(new_max: int) -> void:
	max_health = new_max
	# if current_health > max_health:
	# 	current_health = max_health
	# if hp_display:
	# 	hp_display.set_max_hp(max_health)
	# 	hp_display.refresh_hp(current_health)

func get_functional_max_health() -> int:
	if is_player:
		return StatCalculator.get_player_max_health()
	return max_health 

func is_dead() -> bool:
	return current_health <= 0
	
