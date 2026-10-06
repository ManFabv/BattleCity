class_name EntityLevels
extends Resource

@export_group("Config")
## one config per level; index 0 is the starting level
@export var _level_configs : Array[EntityLevelConfig]
@export_group("Archetype")
## seconds an AI-controlled entity of this archetype has to reach a wander target; the player ignores it
@export_range(0.1, 20.0) var ai_wander_timeout_seconds : float = 10.0:
	set(new_value):
		# we prevent negative timeouts
		ai_wander_timeout_seconds = maxf(new_value, 0.0)


## config for the given level index, clamped to the available levels; null with an error when there are none
func level_at(index: int) -> EntityLevelConfig:
	# without levels the clamp would give -1 and index an empty array
	if last_index() < 0:
		push_error("%s has no level configs" % resource_path)
		return null
	# we keep the index inside the available levels
	var clamped_index : int = clampi(index, 0, last_index())
	return _level_configs[clamped_index]


## index of the last (highest) level
func last_index() -> int:
	return _level_configs.size() - 1
