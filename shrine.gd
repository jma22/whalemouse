extends Node3D
class_name Shrine

@export var sprite : Sprite3D
@export var floating_sprite : Sprite3D
@export var area : Area3D
@export var blessing_description : BlessingText
@export var animation_player : AnimationPlayer

var player_inside : bool = false
var upgrade_name : String = ""
var activated : bool = false
func _ready() -> void:
	area.connect("body_entered", Callable(self, "_on_body_entered"))
	area.connect("body_exited", Callable(self, "_on_body_exited"))


func setup(_upgrade_name: String) -> void:
	floating_sprite.texture = load("res://Icons/%s.png" % _upgrade_name)
	upgrade_name = _upgrade_name
	activated = false
	animation_player.play("shrine_on")
	floating_sprite.visible = true




func _process(delta: float) -> void:
	if player_inside:
		if Input.is_action_just_pressed("ui_accept"):
			GlobalStats.add_to_stat(upgrade_name)
			activated = true
			floating_sprite.visible = false


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		sprite.modulate = Color(1, 0, 0) # Change color to red when player enters
		player_inside = true
		blessing_description.display_blessing_info(upgrade_name)


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		sprite.modulate = Color(1, 1, 1) # Change color back
		player_inside = false
		blessing_description.exit_blessing_info()


func open_gateway() -> void:
	area.set_monitorable(true)
	area.set_monitoring(true)
	sprite.visible = true

func close_gateway() -> void:
	area.set_monitorable(false)
	area.set_monitoring(false)
	sprite.visible = false
	floating_sprite.visible = false
