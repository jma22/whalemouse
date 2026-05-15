extends RefCounted
class_name CostData

var dictionary : Dictionary[StringName, int]


func _init() -> void:
	dictionary = {}

func add_cost(cost_type: StringName, amount: int) -> CostData:
	dictionary[cost_type] = amount
	return self

func can_afford() -> bool:
	var player_currency : Dictionary = GameData.get_currency_amount()
	for cost_type : StringName in dictionary.keys():
		if player_currency.get(cost_type, 0) < dictionary[cost_type]:
			return false
	return true

func get_cost(cost_type: StringName) -> int:
	return dictionary.get(cost_type, 0)
