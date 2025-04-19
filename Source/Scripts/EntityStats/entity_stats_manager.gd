class_name EntityStatsManager
extends Node

@export_group("Stats")
## base entity stats before any modification
@export var _base_entity_stats : EntityStats
@export_group("Stats Modifiers")

## a list of different modifiers for the current stats
var _modifiers : Array[EntityStatsModifier]

## we are going to work over this copy to not affect the real resource
var _current_base_entity_stats : EntityStats:
	get():
		# the first time we generate a copy to not affect real stats
		# and we apply the modifiers
		if _current_base_entity_stats == null:
			_current_base_entity_stats = _base_entity_stats.duplicate()
			_apply_modifiers()
		return _current_base_entity_stats


func add_modifier(new_modifier : EntityStatsModifier) -> void:
	new_modifier.init(self)
	new_modifier.on_modifier_depleted.connect(_modifier_depleted)
	_modifiers.append(new_modifier)
	_apply_modifiers()


func remove_modifier(modifier : EntityStatsModifier) -> void:
	modifier.on_modifier_depleted.disconnect(_modifier_depleted)
	_modifiers.erase(modifier)
	_apply_modifiers()


## we apply all entity stats modifiers
func _apply_modifiers() -> void:
	for modifier in _modifiers:
		# we "decorate" the current stats with this current modifier
		_current_base_entity_stats = modifier.apply(_current_base_entity_stats)


## we get the base stats with all entity stats modifiers applied
func entity_stats() -> EntityStats:
	return _current_base_entity_stats


## when we deplete a modifier, we remove it from the list
func _modifier_depleted(modifier: EntityStatsModifier) -> void:
	remove_modifier(modifier)
