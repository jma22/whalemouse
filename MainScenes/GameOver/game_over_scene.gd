extends Node3D

# @export var text_label: RichTextLabel
@export var background : TextureRect
@export var audio_player : AudioStreamPlayer
@export var text_labels : Array[RichTextLabel] # for blessing stats
var label_original_positions : Array[Vector2] = []

@export var game_win_texture : Texture
@export var game_over_texture : Texture
@export var button_control : Control
var screen_height : float = 1080.0
var tween : Tween = null

func _ready() -> void:
	for label in text_labels:
		label_original_positions.append(label.position)
# 	await get_tree().create_timer(2.0).timeout
# 	setup()



func setup() -> void:
	GameData.record_run(GlobalStats.run_stats, GlobalStats.boss_defeated)
	if GlobalStats.boss_defeated:
		background.texture = game_win_texture
	else:
		background.texture = game_over_texture
	screen_height = get_viewport().get_visible_rect().size.y

	button_control.visible = false
	for i :int in range(text_labels.size()):
		text_labels[i].position = label_original_positions[i] - Vector2(0, screen_height)

	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	## drop background from above screen with rebound
	background.position = Vector2(0, -screen_height)
	tween.tween_callback(Callable(self, "play_sound").bind(0))
	# tween.tween_interval(0.1)
	tween.tween_property(background, "position", Vector2(0, 0), 0.6).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_interval(0.2)

	display_stats()
	tween.play()
	await tween.finished
	button_control.visible = true
	button_control.get_child(0).accept_inputs()




func play_sound(i : int) -> void:
	audio_player.pitch_scale = 0.75 + i*0.4 + randf() * 0.1 # randomize pitch a bit
	audio_player.play()

func display_stats() -> void:
	var stats : Dictionary = GlobalStats.run_stats
	var i : int = 0
	for stat_name : String in stats.keys():
		var number : int = int(stats[stat_name])
		var text : String = ""
		if stat_name == "total_time_survived":
			text = "seconds"
		elif stat_name == "waves_completed":
			text = "waves"
		elif stat_name == "enemies_killed":
			text = "fish"
		else:
			continue
		
		text_labels[i].text = "[shake rate=4.0 level=4 connected=1]" + str(number) + " " + text + "[/shake]\n"
		tween.tween_callback(Callable(self, "play_sound").bind(i+1))
		# tween.tween_interval(0.1)
		tween.tween_property(text_labels[i], "position", label_original_positions[i], 0.6).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		tween.tween_interval(0.2)
		i += 1
	
