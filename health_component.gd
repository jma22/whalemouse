extends Node
class_name HealthComponent

func on_hurt(damage: int) -> void:
	print("Ouch! Took ", damage, " damage.")
	