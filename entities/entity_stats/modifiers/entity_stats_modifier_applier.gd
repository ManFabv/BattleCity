class_name EntityStatsModifierApplier
extends RefCounted

## emitted when the modifier reaches its lifetime
signal _depleted(applier: EntityStatsModifierApplier)

## the resource holding this modifier's data and logic
var _entity_stats_modifier : EntityStatsModifierInterface
## the timer that depletes this modifier after its duration
var _duration_timer : CustomTimer


## we cache the modifier, we listen to the depleted event and we request the timer that ends it
func _init(entity_stats_modifier: EntityStatsModifierInterface, on_depleted: Callable, owner_exited: Signal) -> void:
	_entity_stats_modifier = entity_stats_modifier
	# we connect the signal to notify that the modifier is depleted
	_depleted.connect(on_depleted)
	# we keep the timer so the modifier can be cancelled before it depletes
	_duration_timer = entity_stats_modifier.create_duration_timer(_deplete_modifier, owner_exited)


## we apply the modifier logic using the config resource
func apply(stats: EntityStats) -> void:
	_entity_stats_modifier.apply(stats)


## true if this applier was created from the given modifier resource
func is_created_from(entity_stats_modifier: EntityStatsModifierInterface) -> bool:
	return _entity_stats_modifier == entity_stats_modifier


## stops the duration timer, so this modifier never depletes (ex: a new pickup of the same modifier replaced it)
func cancel() -> void:
	_duration_timer.cancel()


## this marks the modifier as depleted
func _deplete_modifier() -> void:
	_depleted.emit(self)
