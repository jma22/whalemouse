extends WaveInfo

class_name ChoiceWaveInfo
var blessings : Array[UpgradeData] = []

static func create(wave_number: int, blessings: Array[UpgradeData], name: String = "") -> ChoiceWaveInfo:
    var wave_info : ChoiceWaveInfo = ChoiceWaveInfo.new()
    wave_info.wave_number = wave_number
    wave_info.blessings = blessings
    wave_info.room_type = "shrine"
    wave_info.name = name
    return wave_info
