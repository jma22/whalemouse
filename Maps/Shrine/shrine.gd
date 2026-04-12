extends Node3D
class_name Shrine

@export var sprite : SpriteManager
@export var floating_sprite : Sprite3D
@export var area : Area3D
@export var blessing_description : BlessingText
@export var animation_player : AnimationPlayer

var upgrade_data : UpgradeData
var player_inside : bool = false
var activated : bool = false

var animation_clip : AnimationClip
var tween : Tween = null

var original_scale : Vector3

@export var audio_player : AudioStreamPlayer
func _ready() -> void:
	area.connect("body_entered", Callable(self, "_on_body_entered"))
	area.connect("body_exited", Callable(self, "_on_body_exited"))
	animation_clip = AnimationClip.new()
	animation_clip.frame_numbers = [0,1,2]
	original_scale = sprite.scale

func setup(upgrade_data_: UpgradeData) -> void:
	if upgrade_data_ == null:
		activated = false
		sprite.visible = false
		printerr("Shrine setted up with no upgrade")
		return
		
	floating_sprite.texture = load(upgrade_data_.get_icon_path())
	upgrade_data = upgrade_data_
	activated = false
	animation_player.play("shrine_on")
	floating_sprite.visible = true


func _process(_delta: float) -> void:
	if player_inside:
		if Input.is_action_just_pressed("interact"):
			upgrade_data.apply()
			activated = true
			floating_sprite.visible = false
			audio_player.play()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		TutorialManager.show_tutorial(TutorialManager.TutorialEnum.OVERSHRINE)

		sprite.modulate = Color(0.7, 0.8, 0.8) # Change color to red when player enters
		player_inside = true
		blessing_description.display_blessing_info(upgrade_data)
		sprite.frames_per_second = 5
		if tween:
			tween.stop()
		tween = create_tween()
		tween.set_parallel(true)
		## grow a little bigger, opaque, slow rotation
		tween.tween_property(sprite, "scale", Vector3(0.05,0.05,0.05), 0.3).as_relative().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(sprite, "modulate:a", 1.0, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.play()


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		sprite.modulate = Color(1, 1, 1) # Change color back
		player_inside = false
		blessing_description.exit_blessing_info()
		sprite.frames_per_second = 1.6
		if tween:
			tween.stop()
		tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(sprite, "scale", Vector3(-0.05,-0.05,-0.05), 0.3).as_relative().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(sprite, "modulate:a", 0.6, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.play()


func open_gateway() -> void:
	area.set_monitorable(true)
	area.set_monitoring(true)
	sprite.visible = true
	sprite.play(animation_clip)
	if not player_inside:
		sprite.modulate.a = 0.6

func close_gateway() -> void:
	area.set_monitorable(false)
	area.set_monitoring(false)
	sprite.visible = false
	floating_sprite.visible = false
	sprite.scale = original_scale
	sprite.modulate = Color(1, 1, 1, 1)
