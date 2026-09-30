class_name EntityStatsManager
extends Node

## base entity stats (modifiers will be applied on top of this)
var _base_entity_stats : EntityStats

## a list of active modifiers for the current stats
var _modifiers : Array[EntityStatsModifierApplier]

## we are going to work over this copy to not affect the real resource
var _current_stacked_entity_stats : EntityStats


## we cache the entity stats and apply any modifiers
func configure(new_entity_stats: EntityStats) -> void:
	_base_entity_stats = new_entity_stats
	_apply_modifiers()


## we add the modifier applier and we reapply the others left
## NOTE: that this implementation probably won't work if the have a modifier that is
## increasing or decreasing its modified value because we reapply the modifiers again
func add_modifier(new_entity_stats_modifier: EntityStatsModifier) -> void:
	# we cache the actual instance that will apply the modification
	var applier : EntityStatsModifierApplier = new_entity_stats_modifier.create_new_applier(
			_modifier_depleted, 
			tree_exited)
	# we add the new applier to the list of modifiers
	_modifiers.append(applier)
	# we apply the modifiers
	_apply_modifiers()


## we remove the modifier applier and we reapply the others left
## NOTE: that this implementation probably won't work if the have a modifier that is
## increasing or decreasing its modified value because we reapply the modifiers again
func remove_modifier(modifier: EntityStatsModifierApplier) -> void:
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
func resulting_entity_stats() -> EntityStats:
	return _current_stacked_entity_stats


## when we deplete a modifier, we remove it from the list
func _modifier_depleted(modifier: EntityStatsModifierApplier) -> void:
	remove_modifier(modifier)


## removes every active modifier at once; used when resetting stats (e.g. player death)
func clear_modifiers() -> void:
	# because the modifiers are refcounted, we only need to remove the references from the list
	_modifiers.clear()
	# we recalculate the resulting modifiers (if any but it shouldn't)
	_apply_modifiers()
