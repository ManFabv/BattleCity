class_name EntityStatsModifierInterface
extends Resource

@export_group("References")
## shared timer manager used by the applier to count this duration
@export var _timer_manager : TimerManagerResource

@export_group("Config")
## how much time this stats modifier will be applied
@export_range(0.1, 60.0) var duration : float = 3.0


## We create the runtime applier for this modifier
func create_new_applier(on_depleted: Callable, owner_exited: Signal) -> EntityStatsModifierApplier:
	return EntityStatsModifierApplier.new(self, on_depleted, owner_exited)


## requests the timer that ends this modifier after its duration
func create_duration_timer(on_timeout: Callable, owner_exited: Signal) -> CustomTimer:
	return _timer_manager.create_one_shot(duration, on_timeout, owner_exited)


## Apply this modifier directly to the recalculated runtime values.
func apply(_stats: EntityStats) -> void:
	push_error("apply() should be implemented on inherited classes")
