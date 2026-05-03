extends CollectibleBase
class_name BossFragment

func on_pickup() -> void:
	GlobalStats.add_big_shard()