class_name EntityStatsModifier
extends Resource

## base entity stats
@export var _entity_stats : EntityStats

## we apply the new stats into the base stats
func apply(new_stats: EntityStats) -> EntityStats:
	return _entity_stats
