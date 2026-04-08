extends Node3D
class_name Gateway

@export var sprite : SpriteManager
@export var area : Area3D

var player_inside : bool = false
var done : bool = false
var animation_clip : AnimationClip
var idle_animation_clip : AnimationClip

var tween : Tween = null
var original_scale : Vector3

@export var audio_player : AudioStreamPlayer
@export var portal_hum : AudioStreamPlayer
func _ready() -> void:
	area.connect("body_entered", Callable(self, "_on_body_entered"))
	area.connect("body_exited", Callable(self, "_on_body_exited"))
	animation_clip = AnimationClip.new()
	animation_clip.frame_numbers = [0,1,2]
	idle_animation_clip = AnimationClip.new()
	idle_animation_clip.frame_numbers = [0,1,2]
	original_scale = sprite.scale
	close_gateway()

func _process(delta: float) -> void:
	if player_inside:
		if not done and  Input.is_action_just_pressed("ui_accept"):
			done = true
			audio_player.play()
			SceneManager.next_wave()
			close_gateway()



func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		TutorialManager.show_tutorial(TutorialManager.TutorialEnum.OVERPORTAL)
		sprite.modulate = Color(0.7, 0.8, 0.8)  # Change color to red when player enters
		sprite.frames_per_second = 5
		if tween:
			tween.stop()
		tween = create_tween()
		tween.set_parallel(true)
		## grow a little bigger, opaque, slow rotation
		tween.tween_property(sprite, "scale", Vector3(0.05,0.05,0.05), 0.3).as_relative().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(sprite, "modulate:a", 1.0, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.play()
		player_inside = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		sprite.modulate = Color(1, 1, 1) # Change color back
		# sprite.play(idle_animation_clip)
		sprite.frames_per_second = 1.6
		if tween:
			tween.stop()
		tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(sprite, "scale", Vector3(-0.05,-0.05,-0.05), 0.3).as_relative().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(sprite, "modulate:a", 0.6, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.play()
		player_inside = false


func open_gateway() -> void:
	area.set_monitorable(true)
	area.set_monitoring(true)
	sprite.visible = true
	sprite.play(idle_animation_clip)
	if not player_inside:
		sprite.modulate.a = 0.6

	done = false
	portal_hum.play()
	print("Gateway opened")

func close_gateway() -> void:
	player_inside = false
	area.set_monitorable(false)
	area.set_monitoring(false)
	sprite.visible = false
	portal_hum.stop()
	sprite.scale = original_scale
	sprite.modulate = Color(1, 1, 1, 1)
	print("Gateway closed")
