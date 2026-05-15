extends OptionButton

var diff_list : Array = ["easy", "normal", "hard"]

func _ready() -> void:
	var diff_str : String = Config.get_setting("difficulty", "normal").to_lower()
	selected = diff_list.find(diff_str)
	item_selected.connect(_on_value_changed)
	

func _on_value_changed(index: int) -> void:
	
	Config.set_setting("difficulty", diff_list[index], true)
