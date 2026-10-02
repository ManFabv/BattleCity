class_name OnceBasedSpawnStrategyConfig
extends SpawnStrategyConfig

@export_group("References")
## the scene_to_spawn to instantiate once on the first spawn point
@export var scene_to_spawn : PackedScene


## creates the once based spawn strategy that uses this config's scene_to_spawn
func create_spawn_strategy() -> SpawnStrategyInterface:
	return OnceBasedSpawnStrategy.new(self)
