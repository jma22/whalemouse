extends MapManagerBase
const enemy_string_to_scene = {
	"enemy1": preload("res://Enemies/lunging_enemy/enemy.tscn"),
	"enemy2": preload("res://Enemies/floating_enemy/enemy2.tscn"),
	"SquidMinion": preload("res://Enemies/SquidMinion/squid_minion.tscn")
}
# @export var shrines : Array[Node3D]

		
# func start_room (wave_info : WaveInfo) -> void:
# 	super(wave_info)
	# set_shrines(wave_info.blessings)


func map_cleared() -> bool:
	# for shrine : Shrine in shrines:
	# 	if shrine and shrine.activated:
	# 		return true
	return false

# func on_map_cleared() -> void:
# 	super()
	# for shrine : Shrine in shrines:
	# 	shrine.close_gateway()


func spawn_enemy(enemy_type: String, spawn_point : Vector3) -> void:
	if enemy_type in enemy_string_to_scene:
		var enemy_scene = enemy_string_to_scene[enemy_type]
		var enemy_instance = enemy_scene.instantiate()
		add_child(enemy_instance)
		enemy_instance.global_transform.origin = spawn_point
		enemy_instance.setup(player, floor)
