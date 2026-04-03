extends Node
# class_name TutorialManager

# @export var canvas_layer : CanvasLayer

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
# static var tutorials : Dictionary= {
# 	TutorialEnum.INTRO: ["You own a card museum, the goal is to sustain operations!",
# 						"Display cards and complete sets in your museum to earn income!",
# 						"Here's two packs to get you started!"],
# 	TutorialEnum.FIRST_CARD_HOVER: ["Cards can give income, reputation, or other effects!",
# 									"Cards part of a set will give you bonuses once you have them all!"],
# 	TutorialEnum.LOCKED_CARD: ["This card is locked, you can unlock it by paying the cost shown here!"],
# 	TutorialEnum.FIRST_MUSEUM: ["This is your museum, you can place cards here to earn income and reputation!", "Once you are ready, try going outside!"],
# 	TutorialEnum.FIRST_OUTSIDE: ["This is the outside world, use STAMINA to explore. You can find different people with different cards!.",],
# 	TutorialEnum.FIRST_EXPEDITION_DONE: ["Every time you explore, your museum will earn income based on the cards you have displayed!",
# 	"Once you are done exploring, you can end the day to collect your earnings and return to the museum!"],
# 	TutorialEnum.FIRST_NEW_DAY : ["A new day begins! Every few days, there might be rent due, or reputation requirements to meet, so keep an eye on those!"],
# 	TutorialEnum.FIRST_EVENT_CHECK : ["Upcoming events are shown here.","If you can't pay rent or meet reputation requirements, the museum will close and you'll have to start over!"],
# 	TutorialEnum.FIRST_MUSEUM_RETURN : ["Welcome back to the museum! It seems like the reputation requirements are getting higher. You can check any upcoming events in the top left.","If your reputation is too low, you will lose half your money!"],
# 	TutorialEnum.LOCKED_SET: ["Unlocking a new card set will also increase the reputation threshold for your museum."],
# }

# func on_scene_enter(tutorial_enum : TutorialEnum) -> void:
# 	var tutorial_lines : Array = tutorials.get(tutorial_enum, [])
# 	tutorial_manager.setup(tutorial_lines)
# 	tutorials.erase(tutorial_enum) # Remove the tutorial so it doesn't show again

# static func should_show_tutorial(tutorial_enum : TutorialEnum) -> bool:
# 	print("should show tutorial: %s? %s" % [str(tutorial_enum), str(tutorial_enum in tutorials)])
# 	if SceneManager.get_current_scene_enum() == SceneManager.SceneEnum.TUTORIAL:
# 		print("current tutorial: %s" % str(SceneManager.get_current_scene_enum()))
# 		return false
# 	return tutorial_enum in tutorials

# # func check_tutorial(tutorial_enum : TutorialEnum) -> bool:
# # 	return tutorials.has(tutorial_enum)

# func set_canvas_layer(layer : int) -> void:
# 	canvas_layer.layer = layer
