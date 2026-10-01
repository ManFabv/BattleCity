class_name BaseLevels
extends Resource

## one config per level; index 0 is the starting level
@export var _level_configs : Array[BaseLevelConfig]


## config for the given level index, clamped to the available levels
func level_at(index: int) -> BaseLevelConfig:
	var clamped_index : int = clampi(index, 0, last_index())
	return _level_configs[clamped_index]


## index of the last (highest) level
func last_index() -> int:
	return _level_configs.size() - 1
