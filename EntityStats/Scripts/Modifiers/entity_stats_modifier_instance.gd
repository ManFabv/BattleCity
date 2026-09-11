class_name EntityStatsModifierInstance
extends RefCounted

## signal emitted when the modifier reaches its lifetime or is removed
signal depleted(modifier: EntityStatsModifierInstance)

## here we keep the original resource modifier so this instance can be
## reused for runtime state without mutating the shared `.tres`
var _entity_stats_modifier: EntityStatsModifier


## when created, we cache the original modifier
func _init(entity_stats_modifier: EntityStatsModifier) -> void:
	_entity_stats_modifier = entity_stats_modifier


## this method is meant for runtime setup for modifiers that need it
func initialize(_owner_node: Node) -> void:
	push_error("initialize() should be implemented on inherited")
	pass


## we apply the modifier logic using the original _entity_stats_modifier
func apply(stats: EntityStats) -> void:
	_entity_stats_modifier.apply(stats)


## this marks the runtime instance as depleted and lets the manager remove it
func _deplete() -> void:
	depleted.emit(self)
