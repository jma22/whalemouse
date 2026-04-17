extends RefCounted

class_name ShuffledPool
var _items: Array
var _index: int = 0

func _init(items: Array) -> void:
    _items = items.duplicate()
    _items.shuffle()

func next() -> Node3D:
    var item : Variant = _items[_index]
    _index += 1
    if _index >= _items.size():
        _index = 0
        _items.shuffle()
    return item


static func create_shuffled_pool(points: Array) -> ShuffledPool:
    return ShuffledPool.new(points)