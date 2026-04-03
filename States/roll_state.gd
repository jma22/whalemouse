extends State

class_name RollState
@export var animation : AnimationClip
@export var fps: float = 4.0

var roll_direction : Vector2 = Vector2.ZERO
# @export var roll_speed: float = 10.0	
@export var dampening : float = 0.9
@export var invulnerability_time : float = 0.5
var bubbler_scene : PackedScene = preload("res://Bubbler.tscn")


func enter() -> void:
	# player.sprite_manager.frames_per_second = fps
	entity.sprite_manager.play(animation)
	initial_velocity()
	var bubbler_instance = bubbler_scene.instantiate()
	entity.add_child(bubbler_instance)
	bubbler_instance.start()
	entity.set_invulnerable(true)

func run(delta: float) -> void:
	if invulnerability_time <= get_elapsed_time():
		entity.set_invulnerable(false)
func exit() -> void:
	entity.set_invulnerable(false)

func fixed_run(_delta: float) -> void:
	entity.velocity *= dampening
	if entity.velocity.length() < 1.0:
		is_complete = true

func set_direction(direction: Vector2) -> void:
	roll_direction = direction

func initial_velocity() -> void:
	entity.velocity.x = roll_direction.x * GlobalStats.get_dash_distance()
	entity.velocity.z = roll_direction.y * GlobalStats.get_dash_distance()
