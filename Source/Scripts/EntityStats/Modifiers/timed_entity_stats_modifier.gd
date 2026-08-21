class_name TimedEntityStatsModifier
extends EntityStatsModifier

## Base Event we will need to handle the request for the timers
@export var timer_requested : BaseEvent

## how much time this stats modifier will be applied
@export_range(0, 60) var _duration : float = 3


## Starts the lifetime of this modifier using the Timer Manager
func initialize(owner_node: Node) -> void:
	var timer_context : TimerContext = TimerContext.new(_duration, false, _on_timer_timeout, owner_node.tree_exited)
	timer_requested.emit(timer_context)


## this method is called when the timer reaches its timeout
## so we say that the modifier is depleted
func _on_timer_timeout() -> void:
	# Trigger the notification that this modifier is depleted
	on_modifier_depleted.emit(self)
