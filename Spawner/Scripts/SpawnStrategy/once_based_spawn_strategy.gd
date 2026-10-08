class_name OnceBasedSpawnStrategy
extends SpawnStrategyInterface

## the config with the scene_to_spawn to spawn
var _once_based_spawn_strategy_config : OnceBasedSpawnStrategyConfig


## we cache the config
func _init(config: OnceBasedSpawnStrategyConfig) -> void:
	# we cache the config so we can read the scene when we configure
	_once_based_spawn_strategy_config = config


## we spawn the scene_to_spawn once on the first spawn point
func configure(spawn_points: Array[SpawnPoint], _owner_exited: Signal) -> void:
	# only when there is a spawn point to spawn on
	if spawn_points.size() > 0:
		# we spawn the configured scene once at the first spawn point
		spawn_points[0].spawn(_once_based_spawn_strategy_config.scene_to_spawn)
