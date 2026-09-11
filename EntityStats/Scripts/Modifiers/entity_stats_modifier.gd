class_name EntityStatsModifier
extends Resource


## We create a new instance of the modifier to be applied to the current stats
func create_instance() -> EntityStatsModifierInstance:
	push_error("create_instance() should be implemented on inherited classes")
	return null


## Apply this modifier directly to the recalculated runtime values.
func apply(_stats: EntityStats) -> void:
	push_error("apply() should be implemented on inherited classes")
