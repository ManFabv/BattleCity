class_name EntityStatsModifier
extends Resource


## We create the runtime node that applies this modifier to the current stats
func create_instance() -> StatModifierNode:
	push_error("create_instance() should be implemented on inherited classes")
	return null


## Apply this modifier directly to the recalculated runtime values.
func apply(_stats: EntityStats) -> void:
	push_error("apply() should be implemented on inherited classes")
