extends Button

@export var text_label : RichTextLabel
# Called when the node enters the scene tree for the first time.
var tween : Tween = null
func _ready() -> void:
	#grab_focus() #select when game starts
	pressed.connect(on_clicked)

	mouse_entered.connect(_on_hover_start)
	mouse_exited.connect(_on_hover_end)
	
	focus_entered.connect(_on_hover_start)
	focus_exited.connect(_on_hover_end)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("ui_accept"):
		on_clicked()

func on_clicked() -> void:
	SceneManager.clear_game()
	SceneManager.switch_to(SceneManager.SceneEnum.GAME)
	


func _on_hover_start() -> void:
	if tween and tween.is_valid():
		tween.kill()

	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)

	text_label.text = "[u]"
	text_label.text += "[shake rate=6.0 level=6 connected=1]Click To Start[/shake]"
	text_label.text += "[/u]"


func _on_hover_end() -> void:
	if tween and tween.is_valid():
		tween.kill()

	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)

	text_label.text = "[shake rate=4.0 level=4 connected=1]Click To Start[/shake]"
