class_name EntityStatsModifierInstance
extends RefCounted

## signal emitted when the modifier reaches its lifetime or is removed
signal depleted(modifier: EntityStatsModifierInstance)

## here we keep the original resource modifier so this instance can be
## reused for runtime state without mutating the shared `.tres`
var _entity_stats_modifier: EntityStatsModifier


## we cache the original entity stats modifier during initialization
func _init(entity_stats_modifier: EntityStatsModifier) -> void:
	_entity_stats_modifier = entity_stats_modifier


## base hook for runtime setup; overridden by modifiers that need one (ex: timed ones)
func configure(_owner_node: Node, _on_timer_requested: BaseEvent) -> void:
	push_error("configure() should be implemented on inherited classes")


## we apply the modifier logic using the original _entity_stats_modifier
func apply(stats: EntityStats) -> void:
	_entity_stats_modifier.apply(stats)


## this marks the runtime instance as depleted and lets the manager remove it
func _deplete() -> void:
	depleted.emit(self)
