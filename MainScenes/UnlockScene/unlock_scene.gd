extends Node3D

# @export var text_label: RichTextLabel
@export var background : TextureRect
@export var audio_player : AudioStreamPlayer
@export var relic_name : RichTextLabel
@export var relic_description : RichTextLabel
@export var relic_supplement : RichTextLabel
@export var relic_texture : TextureRect
var label_original_positions : Array[Vector2] = []

@export var button_control : Control
var screen_height : float = 1080.0
var tween : Tween = null

var accept_cooldown : float = 1.0
var accept_timer : float = 0
var accepting_inputs : bool = false

func _ready() -> void:
	accepting_inputs = false
	accept_timer = 0
	# for label in text_labels:
	# 	label_original_positions.append(label.position)
# 	await get_tree().create_timer(2.0).timeout
# 	setup()

func setup(upgrade_internal_name : String) -> void:
	DebugLog.dbg("UnlockScene", "setup called with " + upgrade_internal_name)
	var upgrade_data : UpgradeData = UpgradeRegistry.get_by_name(upgrade_internal_name)
	relic_name.text = shake(upgrade_data.display_name)
	relic_description.text = shake(upgrade_data.get_description())
	relic_supplement.text = shake(upgrade_data.get_supplement_info())
	relic_texture.texture = load(upgrade_data.get_icon_path())

func _process(delta: float) -> void:
	if not accepting_inputs and accept_timer < accept_cooldown:
		accept_timer += delta
	else:
		accepting_inputs = true

	if Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("ui_accept"):
		on_clicked()

func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		on_clicked()
		
func on_clicked() -> void:
	if accepting_inputs:
		SceneManager.next_scene()
	
	# GameData.record_run(GlobalStats.run_stats, GlobalStats.boss_defeated)
	# screen_height = get_viewport().get_visible_rect().size.y

	# button_control.visible = false
	# for i :int in range(text_labels.size()):
	# 	text_labels[i].position = label_original_positions[i] - Vector2(0, screen_height)

	# if tween and tween.is_valid():
	# 	tween.kill()
	# tween = create_tween()
	# ## drop background from above screen with rebound
	# background.position = Vector2(0, -screen_height)
	# tween.tween_callback(Callable(self, "play_sound").bind(0))
	# # tween.tween_interval(0.1)
	# tween.tween_property(background, "position", Vector2(0, 0), 0.6).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	# tween.tween_interval(0.2)

	# display_stats()
	# tween.play()
	# await tween.finished
	# button_control.visible = true




# func play_sound(i : int) -> void:
# 	audio_player.pitch_scale = 0.75 + i*0.4 + randf() * 0.1 # randomize pitch a bit
# 	audio_player.play()


func shake(string : String) -> String:
	return "[shake rate=4.0 level=4 connected=1]" + string + "[/shake]"
# func display_stats() -> void:
# 	var stats : Dictionary = GlobalStats.run_stats
# 	var i : int = 0
# 	for stat_name : String in stats.keys():
# 		var number : int = int(stats[stat_name])
# 		var text : String = ""
# 		if stat_name == "total_time_survived":
# 			text = "seconds"
# 		elif stat_name == "waves_completed":
# 			text = "waves"
# 		elif stat_name == "enemies_killed":
# 			text = "fish"
		
# 		text_labels[i].text = "[shake rate=4.0 level=4 connected=1]" + str(number) + " " + text + "[/shake]\n"
# 		tween.tween_callback(Callable(self, "play_sound").bind(i+1))
# 		# tween.tween_interval(0.1)
# 		tween.tween_property(text_labels[i], "position", label_original_positions[i], 0.6).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
# 		tween.tween_interval(0.2)
# 		i += 1
	
