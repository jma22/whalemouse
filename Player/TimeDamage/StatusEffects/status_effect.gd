extends RefCounted

class_name StatusEffect

var name = ""
var time_remaining : float = 0.0

static func create(name: String, duration: float) -> StatusEffect:
    var effect = StatusEffect.new()
    effect.name = name
    effect.time_remaining = duration
    return effect

func get_multiplier() -> float:
    match name:
        "Freeze":
            return 0.0
        "Slow":
            return 0.5
        "Haste":
            return 1.5
        _:
            return 1.0