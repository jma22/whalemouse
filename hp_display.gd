extends Control
class_name HPDisplay


@export var hp_label : RichTextLabel
@export var life_circle : TextureProgressBar
@export var whale_circle : TextureProgressBar

@export var time_damage : TimeDamageManager
@export var whale_spawner : WhaleSpawner


func setup(player : Node3D) -> void:
	refresh_hp(player.health_component.current_health)
	
func _process(delta: float) -> void:
	set_circle()
	set_whale_circle()


func lose_hp(amount: int, new_hp: int) -> void:
	refresh_hp(new_hp)

func gain_hp(amount: int, new_hp: int) -> void:
	refresh_hp(new_hp)

func refresh_hp(new_hp: int) -> void:
	hp_label.text = str(new_hp)


func set_circle() -> void:
	if time_damage:
		life_circle.value = time_damage.get_progress() * life_circle.max_value
	

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
		else:
			whale_circle.modulate = Color(1, 1, 1, 0.5)
