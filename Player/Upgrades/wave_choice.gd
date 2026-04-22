extends Choice
class_name WaveChoice

var actions: Array[Callable] = []

func _init(_display_name: String = "", _description_func: Callable = Callable(), _actions: Array[Callable] = []) -> void:
	super(_display_name, _description_func)
	actions = _actions

func apply() -> void:
	for action: Callable in actions:
		action.call()

func with_angler_curse() -> WaveChoice:
	var new_actions: Array[Callable] = actions.duplicate()
	new_actions.append(func() -> void: GlobalStats.add_boss_stat(&"num_curses"))
	var orig_desc: Callable = description_func
	var new_desc: Callable = func() -> String:
		return orig_desc.call() + "\n[pulse freq=2.0 color=#960028FF ease=-3.0]Angler's Curse[/pulse]"
	return WaveChoice.new(display_name + "+", new_desc, new_actions)

func with_beluga_blessing() -> WaveChoice:
	var new_actions: Array[Callable] = actions.duplicate()
	new_actions.append(func() -> void: GlobalStats.add_boss_stat(&"num_blessings"))
	var orig_desc: Callable = description_func
	var new_desc: Callable = func() -> String:
		return orig_desc.call() + "\n[rainbow freq=0.6 sat=0.8 val=1.0 speed=0.4]Beluga's Blessing[/rainbow]"
	return WaveChoice.new(display_name + "+", new_desc, new_actions)
