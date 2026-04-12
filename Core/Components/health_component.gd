extends Node
class_name HealthComponent

var hp_display: HPDisplay
var max_health: int
var current_health: int

func setup(hud: HUD, _max_health: int) -> void:
	self.max_health = _max_health
	current_health = max_health
	if hud:
		self.hp_display = hud.hp_display
		self.hp_display.refresh_hp(current_health)


func reset() -> void:
	current_health = max_health
	if hp_display:  
		hp_display.refresh_hp(current_health)


func take_damage(damage: int) -> void:
	print("Taking damage: ", damage , " Current health: ", current_health)
	current_health -= damage
	if current_health <= 0:
		current_health = 0
	if hp_display:
		hp_display.lose_hp(damage, current_health)

func gain_health(amount: int) -> void:
	current_health += amount
	# if current_health > max_health:
	# 	current_health = max_health
	if hp_display:
		hp_display.gain_hp(amount, current_health)

func is_dead() -> bool:
	return current_health <= 0
	
