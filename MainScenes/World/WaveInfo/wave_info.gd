extends RefCounted
class_name WaveInfo

var wave_number : int = 0
var room_type := WaveType.Combat
var name : String = ""

enum WaveType { 
	Combat,
	Shrine,
	Boss,
}
