class_name EntityLevelsConfig
extends Resource

## one config per level; index 0 is the starting level
@export var levels : Array[EntityLevelConfig]

## index of the currently applied level
var current_index : int = 0:
	set(new_value):
		current_index = clamp(new_value, 0, levels.size() - 1)


## config for the currently applied level
func current_level() -> EntityLevelConfig:
	return levels[current_index]
