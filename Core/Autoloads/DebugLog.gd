extends Node

var _file: FileAccess = null
var _opened: bool = false

func entity_name(node: Object) -> String:
	if node == null:
		return "null"
	if node is Hitbox:
		var h : Hitbox = node as Hitbox
		var h_owner : Object = h.get_owner_entity()
		return "hitbox[%s]" % entity_name(h_owner)
	if node is Node:
		var n : Node = node as Node
		var short_id : String = str(n.get_instance_id() % 1000).pad_zeros(3)
		var node_name : String = n.name
		if not node_name.begins_with("@"):
			return "%s#%s" % [node_name, short_id]
		var script : Script = n.get_script() as Script
		if script and script.get_global_name() != "":
			return "%s#%s" % [script.get_global_name(), short_id]
		return "Entity#%s" % short_id
	return str(node)

func dbg_from(object: Object, msg: String) -> void:
	var script: Script = object.get_script() as Script
	var tag: String
	if script and script.get_global_name() != "":
		tag = script.get_global_name()
	else:
		tag = object.get_class()
	dbg(tag, msg)

func dbg(tag: String, msg: String) -> void:
	if not Config.is_enabled("debug_print"):
		return
	_open_if_needed()
	var line := "[%s] %s" % [tag, msg]
	print(line)
	if _file:
		_file.store_line(line)
		_file.flush()

func _open_if_needed() -> void:
	if _opened:
		return
	_opened = true
	var dir := "res://Logs"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir))
	var timestamp := Time.get_datetime_string_from_system().replace("T", "_").replace(":", "-")
	var path := "%s/log_%s.txt" % [dir, timestamp]
	_file = FileAccess.open(path, FileAccess.WRITE)
	if _file:
		_file.store_line("=== %s ===" % Time.get_datetime_string_from_system())
		_file.flush()
