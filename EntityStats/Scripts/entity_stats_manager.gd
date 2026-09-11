class_name EntityStatsManager
extends Node

@export_group("Stats")
## base entity stats before any modification
@export var _base_entity_stats : EntityStats

## a list of active runtime modifier instances for the current stats
var _modifiers : Array[EntityStatsModifierInstance]

## we are going to work over this copy to not affect the real resource
var _current_stacked_entity_stats : EntityStats


func _ready() -> void:
	# we apply the modifiers
	_apply_modifiers()


## we add the modifier and we reapply the others left
## NOTE: that this implementation probably won't work if the have a modifier that is 
## increasing or decreasing its modified value because we reapply the modifiers again
func add_modifier(new_modifier : EntityStatsModifier) -> void:
	var modifier_instance : EntityStatsModifierInstance = new_modifier.create_instance() as EntityStatsModifierInstance
	modifier_instance.depleted.connect(_modifier_depleted)
	_modifiers.append(modifier_instance)
	modifier_instance.initialize(self)
	_apply_modifiers()


## we remove the modifier and we reapply the others left
## NOTE: that this implementation probably won't work if the have a modifier that is 
## increasing or decreasing its modified value because we reapply the modifiers again
func remove_modifier(modifier : EntityStatsModifierInstance) -> void:
	modifier.depleted.disconnect(_modifier_depleted)
	_modifiers.erase(modifier)
	_apply_modifiers()


## we apply all entity stats modifiers
func _apply_modifiers() -> void:
	# we generate a copy to not affect real stats and we apply the modifiers
	_current_stacked_entity_stats = _base_entity_stats.duplicate()
	# we apply all the modifiers
	for modifier in _modifiers:
		# we "decorate" the current stats with this current modifier
		modifier.apply(_current_stacked_entity_stats)


## we get the base stats with all entity stats modifiers applied
func entity_stats() -> EntityStats:
	return _current_stacked_entity_stats


## when we deplete a modifier, we remove it from the list
func _modifier_depleted(modifier: EntityStatsModifierInstance) -> void:
	remove_modifier(modifier)
