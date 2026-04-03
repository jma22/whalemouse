extends Node

enum TutorialEnum {
	INTRO,
	WASDANDSHIFT,
	INTERACT,
	SPACETOATTACK,
	FIRSTKILLXP,
	BLESSSINGS,
	CURSES,
	FIRST_BELUGA,
	GOODLUCK
}
var tutorial : Tutorial = null
var tutorials : Dictionary= {
	TutorialEnum.INTRO: [["Hi there", true], [ "screw you", false], ["just kidding, welcome to Whalemouse!", true]],
}

func setup(tutorial : Tutorial) -> void:
	self.tutorial = tutorial
	process_mode = PROCESS_MODE_ALWAYS

func show_tutorial(tutorial_enum : TutorialEnum) -> void:
	if tutorial_enum not in tutorials:
		return
	var tutorial_lines : Array = tutorials.get(tutorial_enum)
	tutorial.take_tutorial(tutorial_lines)
	tutorials.erase(tutorial_enum) # Remove the tutorial so it doesn't show again


func is_tutorial_blessing(tutorial_enum : TutorialEnum) -> bool:
	return tutorial_enum == TutorialEnum.CURSES

func is_tutorial_active() -> bool:
	return tutorial.displaying_tutorial
