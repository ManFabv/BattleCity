class_name EntityLevels
extends Resource

@export_group("Config")
## one config per level; index 0 is the starting level
@export var _level_configs : Array[EntityLevelConfig]
@export_group("Archetype")
## seconds an AI-controlled entity of this archetype has to reach a wander target; the player ignores it
@export_range(0.1, 20.0) var ai_wander_timeout_seconds : float = 10.0


## config for the given level index, clamped to the available levels
func level_at(index: int) -> EntityLevelConfig:
	var clamped_index : int = clampi(index, 0, last_index())
	return _level_configs[clamped_index]


## index of the last (highest) level
func last_index() -> int:
	return _level_configs.size() - 1
