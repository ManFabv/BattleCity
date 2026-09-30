class_name EntityStatsModifier
extends Resource


## We create the runtime applier for this modifier
func create_new_applier(_on_depleted: Callable, _owner_exited: Signal) -> EntityStatsModifierApplier:
	push_error("create_new_applier() should be implemented on inherited classes")
	return null


## Apply this modifier directly to the recalculated runtime values.
func apply(_stats: EntityStats) -> void:
	push_error("apply() should be implemented on inherited classes")
