extends MapManagerBase

# @export var shrines : Array[Node3D]

		
# func start_room (wave_info : WaveInfo) -> void:
# 	super(wave_info)
	# set_shrines(wave_info.blessings)


func map_cleared() -> bool:
	# for shrine : Shrine in shrines:
	# 	if shrine and shrine.activated:
	# 		return true
	return true

# func on_map_cleared() -> void:
# 	super()
	# for shrine : Shrine in shrines:
	# 	shrine.close_gateway()