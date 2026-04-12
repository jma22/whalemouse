extends MapManagerBase
class_name ShrineMapManager

@export var shrines : Array[Node3D]

		
func start_room (wave_info : WaveInfo) -> void:
	super(wave_info)
	set_shrines(wave_info.blessings)
	player.gain_status_effect(StatusEffect.create("freeze", 4.0))



func set_shrines(blessings: Array[String]) -> void:
	for i in range(shrines.size()):
		if i >= blessings.size():
			shrines[i].setup("")	
			shrines[i].close_gateway()
		else:
			shrines[i].setup(blessings[i])
			shrines[i].open_gateway()


func map_cleared() -> bool:
	for shrine : Shrine in shrines:
		if shrine and shrine.activated:
			return true
	return false

func on_map_cleared() -> void:
	super()
	for shrine : Shrine in shrines:
		shrine.close_gateway()
