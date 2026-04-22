extends MapManagerBase
class_name ShrineMapManager

@export var shrines : Array[Node3D]
var choice_type : ChoiceWaveInfo.ChoiceType


func start_room (wave : WaveInfo) -> void:
	super(wave)
	set_shrines(wave.blessings)
	choice_type = (wave as ChoiceWaveInfo).choice_type
	player.gain_status_effect(FreezeEffect.make(30.0), self)



func set_shrines(blessings: Array[UpgradeData]) -> void:
	for i in range(shrines.size()):
		if i >= blessings.size():
			shrines[i].setup(null)	
			shrines[i].close_gateway()
		else:
			shrines[i].setup(blessings[i])
			shrines[i].open_gateway()


func map_cleared() -> bool:
	match choice_type:
		ChoiceWaveInfo.ChoiceType.SKIPPABLE:
			return true
		ChoiceWaveInfo.ChoiceType.CHOOSE_ALL:
			for shrine : Shrine in shrines:
				if shrine and not shrine.activated and not shrine.unused:
					return false
			return true
		ChoiceWaveInfo.ChoiceType.CHOOSE_ONE:
			for shrine : Shrine in shrines:
				if shrine and shrine.activated:
					return true
			return false
	return false

func on_map_cleared() -> void:
	super()
	if choice_type == ChoiceWaveInfo.ChoiceType.CHOOSE_ONE:
		for shrine : Shrine in shrines:
			shrine.close_gateway()
