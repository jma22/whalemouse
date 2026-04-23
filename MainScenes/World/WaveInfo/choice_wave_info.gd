extends WaveInfo

class_name ChoiceWaveInfo
var blessings : Array[Choice] = []
var choice_type : ChoiceType

enum ChoiceType {
	SKIPPABLE,
	CHOOSE_ONE,
	CHOOSE_ALL,
	# SHOP,
	# TIME_VS_BLESSING,
	# CURSE_OR_BLESSING,
	# CHOOSE_ROOM_TYPE,
	# WHALE_ROOM,
	# TIME_VS_CURSE,
	# TWO_BLESSINGS,
	# TWO_CURSES
}

static func create(wave_number: int, blessings: Array[Choice], choice_type: ChoiceType, name: String = "") -> ChoiceWaveInfo:
	var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
	wave_info.wave_number = wave_number
	wave_info.blessings = blessings
	wave_info.choice_type = choice_type
	wave_info.room_type = "shrine"
	wave_info.name = name
	return wave_info
