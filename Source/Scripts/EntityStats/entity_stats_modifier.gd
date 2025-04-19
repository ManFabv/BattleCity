class_name EntityStatsModifier
extends Resource


## we apply the new stats into the base stats
func apply(_new_stats: EntityStats) -> EntityStats:
	push_error("apply() should be implemented on inherited classes")
	return null
