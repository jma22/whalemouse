extends Control
class_name HPDisplay


@export var hp_label : RichTextLabel
@export var life_circle : TextureProgressBar
@export var whale_circle : TextureProgressBar

@export var time_damage : TimeDamageManager
@export var whale_spawner : WhaleSpawner

var popup_number_scene : PackedScene = load("res://popup_number.tscn")
var life_tween : Tween
var whale_tween : Tween
var played_whale_tween : bool = false
func setup(player : Node3D) -> void:
	refresh_hp(player.health_component.current_health)
	
func _process(delta: float) -> void:
	set_circle()
	set_whale_circle()


func lose_hp(amount: int, new_hp: int) -> void:
	refresh_hp(new_hp)
	var popup_number = popup_number_scene.instantiate() as RichTextLabel
	life_circle.add_child(popup_number)
	popup_number.set_up("-" + str(amount))
	if life_tween:
		life_tween.kill()
	life_tween = create_tween()
	life_tween.tween_interval(0.4)
	life_tween.parallel()
	life_tween.tween_property(life_circle, "scale", Vector2(0.2,0.2), 0.2).as_relative().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	life_tween.tween_property(life_circle, "self_modulate", Color(0.9, 1, 0.9, 1.0), 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	life_tween.chain()
	life_tween.tween_property(life_circle, "scale", Vector2(-0.2,-0.2), 0.2).as_relative().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	life_tween.parallel()
	life_tween.tween_property(life_circle, "self_modulate", Color(1, 1, 1, 1), 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)



func gain_hp(amount: int, new_hp: int) -> void:
	refresh_hp(new_hp)
	var popup_number = popup_number_scene.instantiate() as RichTextLabel
	life_circle.add_child(popup_number)
	popup_number.set_up("+" + str(amount))
	if life_tween:
		life_tween.kill()
	life_tween = create_tween()
	life_tween.tween_interval(0.4)
	life_tween.tween_property(life_circle, "scale", Vector2(1.2,1.2), 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	life_tween.parallel()
	life_tween.tween_property(life_circle, "self_modulate", Color(1, 0.9, 0.9, 1.0), 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	life_tween.chain()
	life_tween.tween_property(life_circle, "scale", Vector2(1.0,1.0), 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	life_tween.parallel()
	life_tween.tween_property(life_circle, "self_modulate", Color(1, 1, 1, 1), 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)





func refresh_hp(new_hp: int) -> void:
	hp_label.text = "[wave amp=1.0 freq=0.5]" + str(new_hp) + "[/wave]"


func set_circle() -> void:
	if time_damage:
		life_circle.value = (1-time_damage.get_progress()) * life_circle.max_value
	

func set_whale_circle() -> void:
	if whale_spawner:
		if not GlobalStats.has_beluga():
			whale_circle.visible = false
			return
		whale_circle.visible = true
		var progress = whale_spawner.get_cooldown_progress()
		whale_circle.value = progress * whale_circle.max_value
		# make sprite grayscale
		if progress == 1.0:
			whale_circle.modulate = Color(1, 1, 1, 1)
			if not played_whale_tween:
				whale_tween = create_tween()
				whale_tween.tween_property(whale_circle, "scale", Vector2(0.04, 0.04), 0.2).as_relative().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
				whale_tween.chain()
				whale_tween.tween_property(whale_circle, "scale", Vector2(-0.04,-0.04), 0.2).as_relative().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
				played_whale_tween = true
		else:
			whale_circle.modulate = Color(1, 1, 1, 0.5)
			played_whale_tween = false
