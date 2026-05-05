class_name MemoryUnlockable

var parent_name : String
var index : int
var name : String
var cost : CostData
var illustration_path : String
var illustration_description : String
var gated_upgrades : Array[StringName] = []

func _to_string() -> String:
    return parent_name + "_" + str(index)