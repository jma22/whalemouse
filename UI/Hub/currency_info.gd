extends HBoxContainer

class_name CurrencyInfoBar

@export var big_num : RichTextLabel
@export var small_num : RichTextLabel
@export var cursed_num : RichTextLabel

func _ready() -> void:
	GameData.on_currency_changed.connect(_on_currency_changed)

func _on_currency_changed(_stat_name: StringName, _new_value: int) -> void:
	sync_bar()

func sync_bar() -> void:
	var currency : Dictionary[String, int] = GameData.get_currency_amount()
	big_num.text = str(currency["num_big_shards"])
	small_num.text = str(currency["num_small_shards"])
	cursed_num.text = str(currency["num_cursed_shards"])

