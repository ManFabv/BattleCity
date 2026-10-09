class_name EntityLevels
extends Resource

@export_group("Config")
## one config per level; index 0 is the starting level
@export var _level_configs : Array[EntityLevelConfig]


## config for the given level index, clamped to the available levels; null with an error when there are none
func level_at(index: int) -> EntityLevelConfig:
	# an archetype without levels can't be configured, we report which resource is wrong
	if _level_configs.is_empty():
		push_error("EntityLevels %s has no level configs" % resource_path)
		return null
	# we keep the index inside the available levels
	var clamped_index : int = clampi(index, 0, last_index())
	return _level_configs[clamped_index]


## index of the last (highest) level
func last_index() -> int:
	return _level_configs.size() - 1
