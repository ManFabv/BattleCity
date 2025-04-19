class_name EntityStatsModifier
extends Resource

## we are going to call this when a modifier is depleted
signal on_modifier_depleted(EntityStatsModifier)


## here we should initialize whats needed
func init(_owner: Node) -> void:
	push_error("init() should be implemented on inherited classes")


## we apply the new stats into the base stats
func apply(_new_stats: EntityStats) -> EntityStats:
	push_error("apply() should be implemented on inherited classes")
	return null
