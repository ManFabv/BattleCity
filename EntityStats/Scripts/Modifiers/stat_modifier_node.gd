class_name StatModifierNode
extends Node

## emitted when the modifier reaches its lifetime
signal depleted(modifier: StatModifierNode)

## the resource holding this modifier's data and logic
@export var config : EntityStatsModifier


## we apply the modifier logic using the config resource
func apply(stats: EntityStats) -> void:
	config.apply(stats)


## this marks the modifier as depleted and removes it
func _deplete() -> void:
	depleted.emit(self)
	queue_free()
