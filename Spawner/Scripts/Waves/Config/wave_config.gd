class_name WaveConfig
extends Resource

@export_group("Config")
## one config per spawn; index 0 is the first spawn
@export var _spawn_configs : Array[WaveSpawnConfig]


## config for the given spawn index
func spawn_at(index: int) -> WaveSpawnConfig:
	return _spawn_configs[index]


## index of the last spawn
func last_index() -> int:
	return _spawn_configs.size() - 1
