extends Resource
class_name AnimationClip

@export var frame_numbers : Array[int] = []
@export var name : String = ""


func is_empty() -> bool:
	return frame_numbers.is_empty()