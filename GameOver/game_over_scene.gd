extends Node3D

# @export var text_label: RichTextLabel
@export var background : TextureRect
@export var audio_player : AudioStreamPlayer
@export var text_labels : Array[RichTextLabel] # for blessing stats

@export var button_control : Control
var tween : Tween = null

func _ready() -> void:
	setup()

func setup() -> void:
	button_control.visible = false
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	## drop background from above screen with rebound
	background.position = Vector2(0, -background.texture.get_size().y)
	tween.tween_callback(Callable(self, "play_sound").bind(0))
	# tween.tween_interval(0.1)
	tween.tween_property(background, "position", Vector2(0, 0), 0.6).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_interval(0.2)

	display_stats()
	tween.play()
	await tween.finished
	button_control.visible = true




func play_sound(i : int) -> void:
	audio_player.pitch_scale = 0.75 + i*0.4 + randf() * 0.1 # randomize pitch a bit
	audio_player.play()

func display_stats() -> void:
	var stats : Dictionary = GlobalStats.total_stats
	var i : int = 0
	for stat_name in stats.keys():
		var number : int = int(stats[stat_name])
		var text : String = ""
		if stat_name == "total_time_survived":
			text = "seconds"
		elif stat_name == "waves_completed":
			text = "waves"
		elif stat_name == "enemies_killed":
			text = "fish"
		
		text_labels[i].text = "[shake rate=4.0 level=4 connected=1]" + str(number) + " " + text + "[/shake]\n"
		text_labels[i].position -= Vector2(0, background.texture.get_size().y)
		tween.tween_callback(Callable(self, "play_sound").bind(i+1))
		# tween.tween_interval(0.1)
		tween.tween_property(text_labels[i], "position", text_labels[i].position + Vector2(0, background.texture.get_size().y), 0.6).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		tween.tween_interval(0.2)
		i += 1
	
