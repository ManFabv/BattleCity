class_name EntityLevels
extends Resource

## one config per level; index 0 is the starting level
@export var levels : Array[EntityLevelConfig]


## config for the given level index, clamped to the available levels
func level_at(index: int) -> EntityLevelConfig:
	return levels[clampi(index, 0, levels.size() - 1)]


## index of the last (highest) level
func last_index() -> int:
	return levels.size() - 1
