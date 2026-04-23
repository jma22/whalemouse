extends ProjectileBase

@export var indicator_sprite : Sprite3D
@export var animation_player : AnimationPlayer
@onready var hitbox : Hitbox = $Indicator/Hitbox

var tween : Tween

func _ready() -> void:
	indicator_sprite.visible = false
	hitbox.damage_type = DamageInfo.DamageType.SPIKE

func setup(delay : float, source_: Node3D) -> void:
	super.set_source(source_)
	hitbox.source = source
	tween = get_tree().create_tween()
	tween.tween_callback(indicator_sprite.show)
	tween.tween_interval(delay - 0.1)
	tween.tween_callback(indicator_sprite.hide)
	tween.tween_callback(animation_player.play.bind("spike_up"))
	tween.tween_interval(animation_player.get_animation("spike_up").length)
	tween.tween_callback(queue_free)
	
