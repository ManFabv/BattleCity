class_name EntityStatsModifier
extends Resource

@warning_ignore_start("unused_signal")
## we are going to call this when a modifier is depleted
signal on_modifier_depleted(EntityStatsModifier)
@warning_ignore_restore("unused_signal")

## here we should initialize whats needed
func initialize(_owner_node: Node) -> void:
	push_error("initialize() should be implemented on inherited classes")


## Apply this modifier directly to the recalculated runtime values.
func apply(_stats: EntityStats, _state: EntityState) -> void:
	push_error("apply() should be implemented on inherited classes")
