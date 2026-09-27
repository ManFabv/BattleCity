class_name TimedEntityStatsModifier
extends EntityStatsModifier

## how much time this stats modifier will be applied
@export_range(0, 60) var duration : float = 3.0
## shared timer manager used by the runtime node to count this duration
@export var timer_manager : TimerManagerResource


## every timed modifier uses the same runtime node; subtypes only change apply()
func create_instance() -> StatModifierNode:
	return TimedStatModifierNode.new() as StatModifierNode
