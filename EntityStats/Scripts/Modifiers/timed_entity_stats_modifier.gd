class_name TimedEntityStatsModifier
extends EntityStatsModifier

## how much time this stats modifier will be applied
@export_range(0.1, 60.0) var duration : float = 3.0
## shared timer manager used by the applier to count this duration
@export var timer_manager : TimerManagerResource


## every timed modifier uses the same applier; subtypes only change apply()
func create_new_applier(on_depleted: Callable, owner_exited: Signal) -> EntityStatsModifierApplier:
	return TimedEntityStatsModifierApplier.new(self, on_depleted, owner_exited)
