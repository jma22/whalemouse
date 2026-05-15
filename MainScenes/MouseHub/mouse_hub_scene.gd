extends Node3D

@export var overworld_button : Button
@export var tab_container : TabContainer

func setup() -> void:
	overworld_button.pressed.connect(on_overworld_button_pressed)
	tab_container.tab_changed.connect(_on_tab_changed)
	_focus_tab_content(tab_container.current_tab)

func on_overworld_button_pressed() -> void:
	SceneManager.switch_to(SceneManager.SceneEnum.OVERWORLD)

func _on_tab_changed(tab_idx : int) -> void:
	_focus_tab_content(tab_idx)

func _focus_tab_content(tab_idx : int) -> void:
	var tab_root : Control = tab_container.get_tab_control(tab_idx)
	if tab_root == null:
		return
	var focusable : Control = _find_focusable(tab_root)
	if focusable:
		focusable.grab_focus()

func _find_focusable(node : Node) -> Control:
	for child : Node in node.get_children():
		if child is Control and (child as Control).focus_mode == Control.FOCUS_ALL:
			return child
		var found : Control = _find_focusable(child)
		if found:
			return found
	return null
