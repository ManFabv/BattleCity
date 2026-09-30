class_name EntityStatsModifier
extends Resource

## how much time this stats modifier will be applied
@export_range(0.1, 60.0) var duration : float = 3.0
## shared timer manager used by the applier to count this duration
@export var timer_manager : TimerManagerResource


## We create the runtime applier for this modifier
func create_new_applier(on_depleted: Callable, owner_exited: Signal) -> EntityStatsModifierApplier:
	return EntityStatsModifierApplier.new(self, on_depleted, owner_exited)


## Apply this modifier directly to the recalculated runtime values.
func apply(_stats: EntityStats) -> void:
	push_error("apply() should be implemented on inherited classes")
