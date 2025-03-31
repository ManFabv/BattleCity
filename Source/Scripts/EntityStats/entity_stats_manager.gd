class_name EntityStatsManager
extends Resource

@export_group("Stats Modifiers")
## a list of different modifiers for the current stats
@export var _modifiers : Array[EntityStatsModifier]


func entity_stats() -> EntityStats:
	var modified_stats : EntityStats
	for modifier in _modifiers:
		modified_stats = modifier.apply(modified_stats)
	return modified_stats
