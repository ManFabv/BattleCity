class_name EntityStatsModifier
extends Resource

@warning_ignore_start("unused_signal")
## we are going to call this when a modifier is depleted
signal on_modifier_depleted(EntityStatsModifier)
@warning_ignore_restore("unused_signal")

## here we should initialize whats needed
func init(_owner_node: Node) -> void:
	push_error("init() should be implemented on inherited classes")


## we apply the new stats into the base stats
func apply(_new_stats: EntityStats) -> EntityStats:
	push_error("apply() should be implemented on inherited classes")
	return null
