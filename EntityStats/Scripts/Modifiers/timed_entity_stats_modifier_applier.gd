class_name TimedEntityStatsModifierApplier
extends EntityStatsModifierApplier

## we request the timer that ends this modifier
func _init(entity_stats_modifier: TimedEntityStatsModifier, on_depleted: Callable, owner_exited: Signal) -> void:
	# we setup the base class
	super(entity_stats_modifier, on_depleted)
	# we also need to create a timer
	entity_stats_modifier.timer_manager.create_one_shot(
			entity_stats_modifier.duration, 
			_deplete_modifier, owner_exited)


## this marks the modifier as depleted
func _deplete_modifier() -> void:
	_on_depleted.emit(self)
