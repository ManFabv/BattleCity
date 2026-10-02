class_name WaveSpawns
extends Resource

@export_group("Config")
## one config per spawn; index 0 is the first spawn
@export var _spawn_configs : Array[WaveSpawnConfig]


## spawn config for the given step of the wave
func get_spawn_config_at(index: int) -> WaveSpawnConfig:
	return _spawn_configs[index]


## index of the last spawn
func last_index() -> int:
	return _spawn_configs.size() - 1
