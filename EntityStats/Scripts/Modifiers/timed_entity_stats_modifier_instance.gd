class_name TimedEntityStatsModifierInstance
extends EntityStatsModifierInstance

## here we keep the runtime timer for the current active modifier instance
var _timer_context: TimerContext


## at the beginning we create a new timer for this specific runtime modifier instance
func initialize(owner_node: Node) -> void:
	var stat_modifier : TimedEntityStatsModifier = _entity_stats_modifier as TimedEntityStatsModifier
	_timer_context = TimerContext.create_one_shot(stat_modifier.duration, _on_timer_timeout, owner_node.tree_exited)
	stat_modifier.timer_requested.emit(_timer_context)


## this method is called when the timer reaches its timeout
## so we say that the modifier is depleted and should be removed from the manager
func _on_timer_timeout() -> void:
	_deplete()
