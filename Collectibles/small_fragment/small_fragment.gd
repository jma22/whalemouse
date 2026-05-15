extends CollectibleBase
class_name SmallFragment

func on_pickup() -> void:
	GlobalStats.add_small_shard()