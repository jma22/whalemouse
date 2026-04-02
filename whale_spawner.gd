extends Node3D

class_name WhaleSpawner
@export var whale : Whale
var cooldown : float = 1.0
var cooldown_timer : float = 0.0
var map_manager : MapManager

func setup(map_manager_ref: MapManager) -> void:
	map_manager = map_manager_ref

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spawn_whale"):
		if can_cast():	
			cast_whale()

func _process(delta: float) -> void:
	if cooldown_timer > 0.0:
		cooldown_timer -= delta
		if cooldown_timer < 0.0:
			cooldown_timer = 0.0


func play_whale() -> void:
	whale.visible = true
	whale.play()
	await whale.whale_animation_player.animation_finished
	whale.visible = false

func can_cast() -> bool:
	return GlobalStats.get_whale_size() > 0 and cooldown_timer <= 0.0

func cast_whale() -> void:
	cooldown_timer = cooldown
	whale.global_transform.origin = map_manager.get_enemy_centroid()
	whale.scale = Vector3.ONE * GlobalStats.get_whale_size()
	play_whale()

func get_cooldown_progress() -> float:

	return 1.0 - (cooldown_timer / cooldown)

