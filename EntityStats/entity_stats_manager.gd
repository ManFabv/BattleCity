class_name EntityStatsManager
extends Node

@export_group("Stats")
## base entity stats before any modification
@export var _base_entity_stats : EntityStats

## a list of different modifiers for the current stats
var _modifiers : Array[EntityStatsModifier]

## we are going to work over this copy to not affect the real resource
var _current_stacked_entity_stats : EntityStats
var _runtime_state: EntityState


func _ready() -> void:
	_runtime_state = EntityState.new()
	# we apply the modifiers
	_apply_modifiers()


## we add the modifier and we reapply the others left
## NOTE: that this implementation probably won't work if the have a modifier that is 
## increasing or decreasing its modified value because we reapply the modifiers again
func add_modifier(new_modifier : EntityStatsModifier) -> void:
	new_modifier.initialize(self)
	new_modifier.on_modifier_depleted.connect(_modifier_depleted)
	_modifiers.append(new_modifier)
	_apply_modifiers()


## we remove the modifier and we reapply the others left
## NOTE: that this implementation probably won't work if the have a modifier that is 
## increasing or decreasing its modified value because we reapply the modifiers again
func remove_modifier(modifier : EntityStatsModifier) -> void:
	modifier.on_modifier_depleted.disconnect(_modifier_depleted)
	_modifiers.erase(modifier)
	_apply_modifiers()


## we apply all entity stats modifiers
func _apply_modifiers() -> void:
	# we generate a copy to not affect real stats and we apply the modifiers
	_current_stacked_entity_stats = _base_entity_stats.duplicate()
	_runtime_state = EntityState.new()
	# we apply all the modifiers
	for modifier in _modifiers:
		# we "decorate" the current stats with this current modifier
		modifier.apply(_current_stacked_entity_stats, _runtime_state)


## we get the base stats with all entity stats modifiers applied
func entity_stats() -> EntityStats:
	return _current_stacked_entity_stats


## Runtime logical state rebuilt together with the numeric stats.
func entity_state() -> EntityState:
	return _runtime_state


## when we deplete a modifier, we remove it from the list
func _modifier_depleted(modifier: EntityStatsModifier) -> void:
	remove_modifier(modifier)
