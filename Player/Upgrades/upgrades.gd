extends Node
class_name Upgrades

var DATA := {
	"heal": UpgradeData.new("Time on a Jar", "blessing", _heal_desc),
	"xp_suck": UpgradeData.new("Orb Catcher", "blessing", _xp_suck_desc),
	"enemy_xp_drop": UpgradeData.new("Feast Totem", "blessing", _enemy_xp_drop_desc),
	"whale_level": UpgradeData.new("Beluga Plushie", "blessing", _whale_desc),
	"dash_distance": UpgradeData.new("VROOM!!", "blessing", _dash_desc),
	"time_tick_level": UpgradeData.new("Dark Algae", "curse", _time_tick_desc),
	"damage": UpgradeData.new("Little Bite", "curse", _damage_desc),
	"enemy_speed": UpgradeData.new("Flying Shell", "curse", _enemy_speed_desc),
	"enemy_health": UpgradeData.new("Bulk Up", "curse", _enemy_health_desc),
	"enemy_damage": UpgradeData.new("Poseidon's Fury", "curse", _enemy_damage_desc),
}

func _heal_desc(level):
	return "Take some time! (+%d)" % ((1 + level) * 7)

func _damage_desc(level):
	return "Too much time on your hands, take some damage! (-%d)" % ((1 + level) * 5)

func _xp_suck_desc(_level):
	return "Orbs are more attracted to you!"

func _enemy_xp_drop_desc(level):
	if level == 0:
		return "Enemies are more... nutritious?"
	else:
		return "Enemies give even more time!"

func _whale_desc(level):
	if level == 0:
		return "Beluga is here to help!"
	else:
		return "Beluga grows bigger!"

func _dash_desc(level):
	if level == 0:
		return "You can now dash!"
	return "Even more dashing!"

func _time_tick_desc(_level):
	return "Time ticks faster..."

func _enemy_speed_desc(_level):
	return "Enemies are faster!"

func _enemy_health_desc(_level):
	return "Enemies are harder to kill!"

func _enemy_damage_desc(_level):
	return "Enemies deal more damage!"
