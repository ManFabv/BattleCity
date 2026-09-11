class_name TimedEntityStatsModifier
extends EntityStatsModifier

## Base Event we will need to handle the request for the timers
@export var timer_requested : BaseEvent

## how much time this stats modifier will be applied
@export_range(0, 60) var duration : float = 3.0


## We create a new instance of the modifier to be applied to the current stats
func create_instance() -> EntityStatsModifierInstance:
	return TimedEntityStatsModifierInstance.new(self)
