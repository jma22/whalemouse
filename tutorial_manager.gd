extends Node

enum TutorialEnum {
	INTRO,
	OVERSHRINE,
	OVERPORTAL,
	FIRSTARRIVE,
	FIRST_CURSE,
	FIRST_BELUGA,
	FIRST_DASH,
	CURSE_OF_THE_DEPTHS,
	GOODLUCK,
	SECOND_CHOICE,
}
var tutorial : Tutorial = null
var tutorials : Dictionary= {
	TutorialEnum.INTRO: [["You're running out of time... [Space]", true], 
		["You must go deeper and find more time.", true], 
		[ "No he doesn't", false], 
		["...?", true],
		[ "To continue is just more work", false], 
		["Don't mind him. Use [WASD] to move around", true]
	],
	TutorialEnum.OVERSHRINE: [["Let me help you out...", true], 
		["Use [Space] to choose one of these blessings. Trust me it'll help you out!", true],
		["Then why don't you just give him both?", false]
	],
	TutorialEnum.OVERPORTAL: [["Let's keep going, you don't have much time left!", true]],
	TutorialEnum.FIRSTARRIVE: [["Press [Space] to step on your enemies, don't forget to pick up those orbs to get some more time!", true],
		["Why don't you try stepping on these poor guys yourself?", false]
	],
	TutorialEnum.FIRST_CURSE: [["Why don't you let me help you out a bit?", false],
		["You're just making this harder!", true],
		["It's called helping him \'move on\'.", false]
	],
	TutorialEnum.SECOND_CHOICE: [["If you can't make up your mind, try pressing [esc]", false],
		["I think that's cheating.", true],
		["Oh so now you want him to have less time?", false]
	],
	TutorialEnum.CURSE_OF_THE_DEPTHS: [["I'll make this easier for you.", false],
		["I think you're supposed to give him two choices", true],
		["Too bad", false]
	],
	TutorialEnum.FIRST_BELUGA: [["Let me help you.", true],
		["Wait you can do that?", false],
		["Press [j] to summon me.", true]
	],

	TutorialEnum.FIRST_DASH: [["Press [shift] to dash - it saves some time.", true],
		["Saves time to buy more time to save time... For what?", false]
	],
	TutorialEnum.GOODLUCK: [["You're doing great. You got this!", true],
		["Got more time to lose", false]]
		
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

func is_tutorial_active() -> bool:
	return tutorial.displaying_tutorial

func pause_tutorial() -> void:
	tutorial.process_mode = Node.PROCESS_MODE_DISABLED

func resume_tutorial() -> void:
	tutorial.process_mode = Node.PROCESS_MODE_ALWAYS

