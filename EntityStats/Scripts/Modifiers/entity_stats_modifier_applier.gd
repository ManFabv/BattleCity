class_name EntityStatsModifierApplier
extends RefCounted

## emitted when the modifier reaches its lifetime
signal _depleted(applier: EntityStatsModifierApplier)

## the resource holding this modifier's data and logic
var _entity_stats_modifier : EntityStatsModifierInterface


## we cache the modifier, we listen to the depleted event and we request the timer that ends it
func _init(entity_stats_modifier: EntityStatsModifierInterface, on_depleted: Callable, owner_exited: Signal) -> void:
	_entity_stats_modifier = entity_stats_modifier
	# we connect the signal to notify that the modifier is depleted
	_depleted.connect(on_depleted)
	# we also need to create a timer
	entity_stats_modifier.timer_manager.create_one_shot(
			entity_stats_modifier.duration, 
			_deplete_modifier, 
			owner_exited)


## we apply the modifier logic using the config resource
func apply(stats: EntityStats) -> void:
	_entity_stats_modifier.apply(stats)


## this marks the modifier as depleted
func _deplete_modifier() -> void:
	_depleted.emit(self)
