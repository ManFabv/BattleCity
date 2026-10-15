class_name OnceBasedSpawnStrategy
extends SpawnStrategyInterface

## the config with the scene_to_spawn to spawn
var _once_based_spawn_strategy_config : OnceBasedSpawnStrategyConfig


## we cache the config
func _init(once_based_spawn_strategy_config: OnceBasedSpawnStrategyConfig) -> void:
	# we cache the config so we can read the scene when we start
	_once_based_spawn_strategy_config = once_based_spawn_strategy_config


## we spawn the scene_to_spawn once on the first spawn point, the config validated that there is one
func start(spawn_points: Array[SpawnPoint], _owner_exited: Signal) -> void:
	# we spawn the configured scene once at the first spawn point
	spawn_points[0].spawn(_once_based_spawn_strategy_config.scene_to_spawn)
