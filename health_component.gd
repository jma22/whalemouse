extends Node
class_name HealthComponent

@export var max_health: int = 10
var current_health: int = max_health

func take_damage(damage: int) -> void:
	print("Taking damage: ", damage , " Current health: ", current_health)
	current_health -= damage
	if current_health <= 0:
		current_health = 0

func is_dead() -> bool:
	return current_health <= 0
	
