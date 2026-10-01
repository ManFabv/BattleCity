class_name WaveSpawnerConfig
extends Resource

## one config per spawn; index 0 is the first spawn
@export var _spawn_configs : Array[WaveSpawnConfig]


## config for the given spawn index, clamped to the available spawns
func spawn_at(index: int) -> WaveSpawnConfig:
	var clamped_index : int = clampi(index, 0, last_index())
	return _spawn_configs[clamped_index]


## index of the last spawn
func last_index() -> int:
	return _spawn_configs.size() - 1
