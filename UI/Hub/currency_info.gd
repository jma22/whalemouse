extends HBoxContainer

class_name CurrencyInfoBar

@export var big_num : RichTextLabel
@export var small_num : RichTextLabel
@export var cursed_num : RichTextLabel

func _ready() -> void:
	GameData.on_currency_changed.connect(_on_currency_changed)
	sync_bar()

func _on_currency_changed() -> void:
	DebugLog.dbg_from(self, "Currency changed")
	sync_bar()

func sync_bar() -> void:
	var currency : Dictionary[StringName, int] = GameData.get_currency_amount()
	big_num.text = str(currency[GameConstants.BOSS_FRAGMENTS])
	small_num.text = str(currency[GameConstants.SMALL_FRAGMENTS])
	cursed_num.text = str(currency[GameConstants.CURSED_FRAGMENTS])
