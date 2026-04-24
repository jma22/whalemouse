extends RefCounted
class_name Choice

var display_name: String
var description_func: Callable
var effects: Array[Callable] = []
var override_blessing : bool = true

func _init(_display_name: String = "", _description_func: Callable = Callable()) -> void:
	display_name = _display_name
	description_func = _description_func

func get_description() -> String:
	if description_func.is_valid():
		return description_func.call()
	return ""

func apply() -> void:
	for effect: Callable in effects:
		if effect.is_valid():
			effect.call()

func is_blessing() -> bool:
	return override_blessing

func with_beluga_blessing() -> Choice:
	var wrapped: Choice = self
	var orig: Choice = self
	var new_desc: Callable = func() -> String:
		return orig.get_description() + "\n[rainbow freq=0.6 sat=0.8 val=1.0 speed=0.4]Beluga's Blessing[/rainbow]"
	var wrapper: Choice = Choice.new(display_name + "+", new_desc)
	wrapper.effects = [
		func() -> void: wrapped.apply(),
		func() -> void: GlobalStats.add_boss_stat(&"num_blessings"),
	]
	return wrapper

func with_angler_curse() -> Choice:
	var wrapped: Choice = self
	var orig: Choice = self
	var new_desc: Callable = func() -> String:
		return orig.get_description() + "\n[pulse freq=2.0 color=#960028FF ease=-3.0]Angler's Curse[/pulse]"
	var wrapper: Choice = Choice.new(display_name + "+", new_desc)
	wrapper.effects = [
		func() -> void: wrapped.apply(),
		func() -> void: GlobalStats.add_boss_stat(&"num_curses"),
	]
	return wrapper

func with_damage(amount: int) -> Choice:
	var wrapped: Choice = self
	var orig: Choice = self
	var new_desc: Callable = func() -> String:
		return orig.get_description() + "\n[color=#FF0000]Take " + str(amount) + " damage[/color]"
	var wrapper: Choice = Choice.new(display_name + "+", new_desc)
	wrapper.effects = [
		func() -> void: wrapped.apply(),
		func() -> void: GlobalStats.player.damage(amount),
	]
	return wrapper

func with_heal(amount: int) -> Choice:
	var wrapped: Choice = self
	var orig: Choice = self
	var new_desc: Callable = func() -> String:
		return orig.get_description() + "\n[color=#00FF00]Heal " + str(amount) + "[/color]"
	var wrapper: Choice = Choice.new(display_name + "+", new_desc)
	wrapper.effects = [
		func() -> void: wrapped.apply(),
		func() -> void: GlobalStats.player.heal(amount),
	]
	return wrapper

func get_icon_path() -> String:
	return Choice.get_icon_path_for(&"")

static func get_icon_path_for(internal_name: StringName) -> String:
	var correct_path: String = "res://UI/HUD/BlessingIcons/%s.png" % internal_name
	var placeholder_path: String = "res://UI/HUD/BlessingIcons/Placeholders/%s.png" % internal_name
	if ResourceLoader.exists(correct_path):
		return correct_path
	return placeholder_path
