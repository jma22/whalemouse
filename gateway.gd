extends Node3D
class_name Gateway

@export var sprite : Sprite3D
@export var area : Area3D

var player_inside : bool = false

func _ready() -> void:
	area.connect("body_entered", Callable(self, "_on_body_entered"))
	area.connect("body_exited", Callable(self, "_on_body_exited"))

func _process(delta: float) -> void:
	if player_inside:
		if Input.is_action_just_pressed("ui_accept"):
			SceneManager.next_wave()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		sprite.modulate = Color(1, 0, 0) # Change color to red when player enters
		player_inside = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		sprite.modulate = Color(1, 1, 1) # Change color back
		player_inside = false


func open_gateway() -> void:
	area.set_monitorable(true)
	area.set_monitoring(true)
	sprite.visible = true
func close_gateway() -> void:
	area.set_monitorable(false)
	area.set_monitoring(false)
	sprite.visible = false
