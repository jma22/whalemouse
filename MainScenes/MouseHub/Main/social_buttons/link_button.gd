extends TextureButton

@export var icon: Texture2D
@export var url: String = ""

func _ready() -> void:
	if icon:
		texture_normal = icon
	pivot_offset = size / 2
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_pressed() -> void:
	if url != "":
		OS.shell_open(url)

func _on_mouse_entered() -> void:
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.2)
	tween.parallel().tween_property(self, "rotation_degrees", 5.0 * [1, -1].pick_random(), 0.1)
	tween.parallel().tween_property(self, "rotation_degrees", 0.0, 0.1).set_delay(0.1)
	

func _on_mouse_exited() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.2)
