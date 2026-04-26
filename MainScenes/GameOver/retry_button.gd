extends Button

@export var text_label : RichTextLabel
# Called when the node enters the scene tree for the first time.
var tween : Tween = null
var accepting_inputs : bool = false
func _ready() -> void:
	accepting_inputs = false
	pressed.connect(on_clicked)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("ui_accept"):
		on_clicked()

func on_clicked() -> void:
	if accepting_inputs:
		SceneManager.next_scene()

func _on_mouse_entered() -> void:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.tween_property(self,"scale", Vector2(1.1, 1.1), 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.play()
	text_label.text = "[u]"
	text_label.text += "[shake rate=6.0 level=6 connected=1]Next[/shake]"
	text_label.text += "[/u]"

func _on_mouse_exited() -> void:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.tween_property(self,"scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.play()
	text_label.text = "[shake rate=4.0 level=4 connected=1]Next[/shake]"

func accept_inputs() -> void:
	accepting_inputs = true
