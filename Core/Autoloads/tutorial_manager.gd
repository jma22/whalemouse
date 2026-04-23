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
	EBB_ORB,
	BLEED,
	BELUGAS_BLESSING,
	ANGLERS_CURSE,
	BOSS_OPTION,
	FUNNY
}
var tutorial : Tutorial = null
var tutorials : Dictionary= {
	TutorialEnum.INTRO: [["You're running out of time... [Press Space]", true], 
		["You must go deeper and find more time.", true], 
		["When you're strong enough, you can go after the one who did this to you.", true], 
		["But only when you are ready.", true],
		["Who me?", false],
		["Don't mind him. Use [WASD] to move around", true]
	],
	TutorialEnum.OVERSHRINE: [["Let me help you out...", true], 
		["Use [Space] to choose one of these blessings. Trust me it'll help you out!", true],
		["Then why don't you just give him both?", false]
	],
	# TutorialEnum.OVERPORTAL: [["Let's keep going, you don't have much time left!", true]],
	TutorialEnum.FIRSTARRIVE: [["Press [Space] to step on your enemies...", true],
	["Don't forget to pick up those orbs to get some more time!", true],
		# ["Why don't you try stepping on these poor guys yourself?", false]
	],
	TutorialEnum.FIRST_CURSE: [["Why don't you let me help you out a bit?", false],
		# ["You're just making this harder!", true],
		# ["It's called helping him \'move on\'.", false]
	],
	TutorialEnum.FUNNY: [["Some choices are harder than others...", true],
		["I can only freeze the curse for 30 seconds while you choose.", true],
		["Actually, maybe you should hurry up.", false]
	],
	# TutorialEnum.SECOND_CHOICE: [["If you can't make up your mind, try pressing [esc]", false],
	# 	["I think that's cheating.", true],
	# 	["Oh so now you want him to have less time?", false]
	# ],
	# TutorialEnum.CURSE_OF_THE_DEPTHS: [["I'll make this easier for you.", false],
	# 	["I think you're supposed to give him two choices", true],
	# 	["Too bad", false]
	# ],
	TutorialEnum.FIRST_BELUGA: [["Let me help you.", true],
		["Press [j/q] to summon me.", true]
	],

	TutorialEnum.FIRST_DASH: [["Press [shift] to dash - it saves some time.", true],
		["To lose to me faster.", false]
	],
	# TutorialEnum.GOODLUCK: [["You're doing great. You got this!", true],
	# 	["Got more time to lose", false]],
	TutorialEnum.EBB_ORB: [["These are ebb orbs! They slow down the curse for one second!", true]],
	TutorialEnum.BLEED: [["You are decaying! The curse runs faster.", false]],
	TutorialEnum.BELUGAS_BLESSING: [["Some shrines will have my blessing.", true],
		["They will give you powerful upgrades before your final encounter.", true],],
	TutorialEnum.ANGLERS_CURSE: [["These shrines will have my curse.", false],
		["They will give me powers instead.", false],],
		
	TutorialEnum.BOSS_OPTION: [["You can choose to fight the boss, or continue to search for more time.", true],
		["...", false],
		["The boss will have his boons, but so will you.", true],
		["Choose wisely.", true]]
}


func _ready() -> void:
	GlobalStats.stat_changed.connect(_on_stat_changed)

func _on_stat_changed(stat_name: StringName, new_value: int) -> void:
	if new_value != 1:
		return
	if stat_name == &"whale_size":
		show_tutorial(TutorialEnum.FIRST_BELUGA)
	elif stat_name == &"dash_distance":
		show_tutorial(TutorialEnum.FIRST_DASH)

func setup(tutorial : Tutorial) -> void:
	self.tutorial = tutorial
	process_mode = PROCESS_MODE_ALWAYS

func show_tutorial(tutorial_enum : TutorialEnum) -> void:
	if tutorial_enum not in tutorials or not Config.is_enabled("tutorial_enabled", true):
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
