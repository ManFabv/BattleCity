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


## we add the modifier applier and we recompute the stats from the base with every active one
func add_modifier(new_entity_stats_modifier: EntityStatsModifierInterface) -> void:
	# we cache the actual instance that will apply the modification
	var applier : EntityStatsModifierApplier = new_entity_stats_modifier.create_new_applier(
			_on_modifier_depleted,
			tree_exited)
	# we add the new applier to the list of modifiers
	_modifiers.append(applier)
	# we apply the modifiers
	_apply_modifiers()


## we get the base stats with all entity stats modifiers applied
func resulting_entity_stats() -> EntityStats:
	return _current_stacked_entity_stats


## we apply all entity stats modifiers
func _apply_modifiers() -> void:
	# a fresh copy every recompute, the modifiers never touch the shared base resource
	_current_stacked_entity_stats = _base_entity_stats.duplicate()
	# we apply all the modifiers
	for modifier in _modifiers:
		# we "decorate" the current stats with this current modifier
		modifier.apply(_current_stacked_entity_stats)


## when a modifier is depleted, we remove it and we reapply the others left
func _on_modifier_depleted(modifier: EntityStatsModifierApplier) -> void:
	# we stop applying the depleted modifier, the list was its only owner so it's freed
	_modifiers.erase(modifier)
	# we recalculate the stats without it
	_apply_modifiers()
