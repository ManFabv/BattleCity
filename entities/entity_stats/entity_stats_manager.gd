class_name EntityStatsManager
extends Node

## base entity stats of the owner, set by configure() (modifiers will be applied on top of this)
var _base_entity_stats : EntityStats

## a list of active modifiers for the current stats
var _modifiers : Array[EntityStatsModifierApplier]

## we are going to work over this copy to not affect the real resource
var _current_stacked_entity_stats : EntityStats


## we replace the base stats, called when the owner is configured for a level, and we apply any modifiers
func configure(new_entity_stats: EntityStats) -> void:
	_base_entity_stats = new_entity_stats
	_apply_modifiers()


## we add the modifier applier and we recompute the stats from the base with every active one
func add_modifier(new_entity_stats_modifier: EntityStatsModifierInterface) -> void:
	# the same modifier picked again replaces the active one instead of stacking on top of it
	_remove_modifier_created_from(new_entity_stats_modifier)
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


## cancels and drops the active applier created from the given modifier, if there is one
func _remove_modifier_created_from(entity_stats_modifier: EntityStatsModifierInterface) -> void:
	for modifier in _modifiers:
		if modifier.is_created_from(entity_stats_modifier):
			# otherwise its timer would still fire later and keep it alive until then
			modifier.cancel()
			# the list was its only owner, so it's freed
			_modifiers.erase(modifier)
			# at most one applier per modifier exists, so we stop before the erase shifts the loop
			return


## when a modifier is depleted, we remove it and we reapply the others left
func _on_modifier_depleted(modifier: EntityStatsModifierApplier) -> void:
	# we stop applying the depleted modifier, the list was its only owner so it's freed
	_modifiers.erase(modifier)
	# we recalculate the stats without it
	_apply_modifiers()
