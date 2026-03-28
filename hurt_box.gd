class_name HurtBox extends Area3D

var owner_entity: Node ## should be a health manaher??

func _ready() -> void:
    area_entered.connect(_on_area_entered)

func _on_area_entered(hitbox: Area3D) -> void:
    if hitbox.has_method("get_damage"):
        owner_entity.on_hit(hitbox.get_damage())