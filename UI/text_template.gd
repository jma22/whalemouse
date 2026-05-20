extends RichTextLabel
class_name TextTemplate

@export var keys: Array[String] = []

var template: String

func _ready() -> void:
	template = text

# Replace the specified word!
func set_values(values: Array[String]) -> void:
	var result := template

	for i in range(min(keys.size(), values.size())):
		result = result.replace(keys[i], values[i])

	text = result
