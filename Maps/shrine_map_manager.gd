extends MapManagerBase
class_name ShrineMapManager

@export var shrines : Array[Node3D]
var is_skippable : bool = false
		
func start_room (wave : WaveInfo) -> void:
	super(wave)
	set_shrines(wave.blessings)
	player.gain_status_effect(StatusEffect.create("freeze", 20.0), self)

func set_shrines(blessings: Array[UpgradeData]) -> void:
	for i in range(shrines.size()):
		if i >= blessings.size():
			shrines[i].setup(null)	
			shrines[i].close_gateway()
		else:
			shrines[i].setup(blessings[i])
			shrines[i].open_gateway()


func map_cleared() -> bool:
	if is_skippable:
		return true
	for shrine : Shrine in shrines:
		if shrine and shrine.activated:
			return true
	return false

func on_map_cleared() -> void:
	super()
	for shrine : Shrine in shrines:
		shrine.close_gateway()
