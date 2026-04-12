extends Node
class_name Upgrades

static var list := {
	"heal": UpgradeData.new("Time on a Jar", true, _heal_desc),
	"xp_suck": UpgradeData.new("Orb Catcher", true, _xp_suck_desc),
	"enemy_xp_drop": UpgradeData.new("Feast Totem", true, _enemy_xp_drop_desc),
	"whale_level": UpgradeData.new("Beluga Plushie", true, _whale_desc),
	"dash_distance": UpgradeData.new("VROOM!!", true, _dash_desc),
	"time_tick_level": UpgradeData.new("Dark Algae", false, _time_tick_desc),
	"damage": UpgradeData.new("Little Bite", false, _damage_desc),
	"enemy_speed": UpgradeData.new("Flying Shell", false, _enemy_speed_desc),
	"enemy_health": UpgradeData.new("Bulk Up", false, _enemy_health_desc),
	"enemy_damage": UpgradeData.new("Poseidon's Fury", false, _enemy_damage_desc),
}

static func _heal_desc(level):
	return "Take some time! (+%d)" % ((1 + level) * 7)

static func _damage_desc(level):
	return "Too much time on your hands, take some damage! (-%d)" % ((1 + level) * 5)

static func _xp_suck_desc(_level):
	return "Orbs are more attracted to you!"

static func _enemy_xp_drop_desc(level):
	if level == 0:
		return "Enemies are more... nutritious?"
	else:
		return "Enemies give even more time!"

static func _whale_desc(level):
	if level == 0:
		return "Beluga is here to help!"
	else:
		return "Beluga grows bigger!"

static func _dash_desc(level):
	if level == 0:
		return "You can now dash!"
	return "Even more dashing!"

static func _time_tick_desc(_level):
	return "Time ticks faster..."

static func _enemy_speed_desc(_level):
	return "Enemies are faster!"

static func _enemy_health_desc(_level):
	return "Enemies are harder to kill!"

static func _enemy_damage_desc(_level):
	return "Enemies deal more damage!"
