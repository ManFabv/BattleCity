class_name EntityStatsModifierApplier
extends RefCounted

## emitted when the modifier reaches its lifetime
signal _on_depleted(applier: EntityStatsModifierApplier)

## the resource holding this modifier's data and logic
var _entity_stats_modifier : EntityStatsModifier


## we cache the modifier and we listen to the depleted event
func _init(entity_stats_modifier: EntityStatsModifier, on_depleted: Callable) -> void:
	# we cache the modifier to apply it later
	_entity_stats_modifier = entity_stats_modifier
	# we connect the signal to notify that the modifier is depleted
	_on_depleted.connect(on_depleted)


## we apply the modifier logic using the config resource
func apply(stats: EntityStats) -> void:
	_entity_stats_modifier.apply(stats)
