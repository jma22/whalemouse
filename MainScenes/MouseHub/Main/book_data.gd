extends Node
class_name BookData

static var chapters := {
	"enemies": {
		"title": "MONSTERS",
		"description": "Learn about what kinda of corrupted creatures you may face in your adventure.",
		"entries": [
			{
				"name": "Vampire-Jelly",
				"description": "A very mysterious creature that wanders about aimsly trying to avoid others that may approach, very easily defeated by stomps.",
				"texture": preload("res://MainScenes/MouseHub/MemoryScene/MainStickers/jellyfish.tres"),
				"lore": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas congue ligula quis nunc scelerisque dignissim. Proin mollis nibh pulvinar nisi hendrerit molestie. "
			},
			{
				"name": "Piranha",
				"description": "A small but rageful creature, lunging at anything that may come across it's path with great biting force.",
				"texture": preload("res://MainScenes/MouseHub/MemoryScene/MainStickers/piranha.png"),
				"lore": "Curabitur id purus eleifend, vehicula lectus nec, elementum lacus. Donec suscipit aliquet nisl. Praesent eleifend placerat lacus, ac commodo elit facilisis id."
			},
			{
				"name": "Hooktopus",
				"description": "A creature that was infused with a strange metalic technology. It uses it's hook to attack any prey that come close to it.",
				"texture": preload("res://MainScenes/MouseHub/MemoryScene/MainStickers/squid_minion.tres"),
				"lore": "Vivamus tincidunt elit diam, non congue ante consectetur at. Mauris viverra aliquam est id tincidunt. Donec vulputate augue at iaculis consectetur."
			},
		]
	},

	"blessings": {
		"title": "BLESSINGS",
		"description": "Learn about the blessed relics that beluga may aid you with.",
		"entries": []
	}
}
