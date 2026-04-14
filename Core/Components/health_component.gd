extends Node
class_name HealthComponent

var hp_display: HPDisplay
var max_health: int
var current_health: int
var entity : CharacterBody3D

var ebb_effect : StatusEffect = StatusEffect.create_conditional("slow")

func setup(_max_health: int, entity: CharacterBody3D) -> void:
	self.max_health = _max_health
	self.entity = entity
	current_health = max_health
	

func link_player_health(hud: HUD) -> void:
	self.hp_display = hud.hp_display
	self.hp_display.refresh_hp(current_health)

	
func reset() -> void:
	current_health = max_health
	if hp_display:  
		hp_display.refresh_hp(current_health)


func take_damage(damage: int) -> void:
	print("Taking damage: ", damage , " Current health: ", current_health)
	current_health -= damage
	if GlobalStats.get_dying_ebb() >= current_health and entity is Player:
		entity.gain_status_effect(ebb_effect, self)

	if current_health <= 0:
		current_health = 0
	if hp_display:
		hp_display.lose_hp(damage, current_health)

func gain_health(amount: int) -> void:
	current_health += amount
	if GlobalStats.get_dying_ebb() < current_health and entity is Player:
		entity.lose_status_effect(ebb_effect, self)
	# if current_health > max_health:
	# 	current_health = max_health
	if hp_display:
		hp_display.gain_hp(amount, current_health)

func is_dead() -> bool:
	return current_health <= 0
	
