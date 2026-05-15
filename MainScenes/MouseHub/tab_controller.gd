extends VBoxContainer

@export var button_1 : Button
@export var button_2 : Button
@export var button_3 : Button

@export var tab_container : TabContainer

var _buttons : Array[Button]
var _button_group : ButtonGroup

func _ready() -> void:
	_buttons = [button_1, button_2, button_3]
	_button_group = ButtonGroup.new()
	_button_group.allow_unpress = false

	for i in _buttons.size():
		var button : Button = _buttons[i]
		button.toggle_mode = true
		button.button_group = _button_group
		button.pressed.connect(_on_tab_button_pressed.bind(i))

	tab_container.tab_changed.connect(_on_tab_changed)
	_sync_pressed_button(tab_container.current_tab)

func _on_tab_button_pressed(tab_idx : int) -> void:
	if tab_container.current_tab != tab_idx:
		tab_container.current_tab = tab_idx
	if tab_container.get_current_tab_control().get_child(0).has_method("close_sticker_detail"):
		tab_container.get_current_tab_control().get_child(0).call("close_sticker_detail")

func _on_tab_changed(tab_idx : int) -> void:
	_sync_pressed_button(tab_idx)

func _sync_pressed_button(tab_idx : int) -> void:
	if tab_idx < 0 or tab_idx >= _buttons.size():
		return
	for i in _buttons.size():
		_buttons[i].set_pressed_no_signal(i == tab_idx)
