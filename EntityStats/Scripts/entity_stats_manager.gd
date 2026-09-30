class_name EntityStatsManager
extends Node

## base entity stats (modifiers will be applied on top of this)
var _base_entity_stats : EntityStats

## a list of active modifiers for the current stats
var _modifiers : Array[StatModifierNode]

## we are going to work over this copy to not affect the real resource
var _current_stacked_entity_stats : EntityStats


## we cache the entity stats and apply any modifiers
func configure(new_entity_stats: EntityStats) -> void:
	_base_entity_stats = new_entity_stats
	_apply_modifiers()


## we add the modifier node and we reapply the others left
## NOTE: that this implementation probably won't work if the have a modifier that is
## increasing or decreasing its modified value because we reapply the modifiers again
func add_modifier(new_config: EntityStatsModifier) -> void:
	var modifier_node : StatModifierNode = new_config.create_instance()
	modifier_node.config = new_config
	modifier_node.depleted.connect(_modifier_depleted)
	add_child(modifier_node)
	_modifiers.append(modifier_node)
	_apply_modifiers()


## we remove the modifier node and we reapply the others left
## NOTE: that this implementation probably won't work if the have a modifier that is
## increasing or decreasing its modified value because we reapply the modifiers again
func remove_modifier(modifier: StatModifierNode) -> void:
	modifier.depleted.disconnect(_modifier_depleted)
	_modifiers.erase(modifier)
	if not modifier.is_queued_for_deletion():
		modifier.queue_free()
	_apply_modifiers()


## we apply all entity stats modifiers
func _apply_modifiers() -> void:
	# we generate a copy to not affect real stats and we apply the modifiers
	# NOTE: this is the documented exception to avoiding .duplicate() (see instructions):
	# a runtime working copy that must be rebuilt from the pristine base on every
	# recompute, since it's reset each time modifiers change, not once per instance
	_current_stacked_entity_stats = _base_entity_stats.duplicate()
	# we apply all the modifiers
	for modifier in _modifiers:
		# we "decorate" the current stats with this current modifier
		modifier.apply(_current_stacked_entity_stats)


## we get the base stats with all entity stats modifiers applied
func entity_stats() -> EntityStats:
	return _current_stacked_entity_stats


## when we deplete a modifier, we remove it from the list
func _modifier_depleted(modifier: StatModifierNode) -> void:
	remove_modifier(modifier)


## removes every active modifier at once; used when resetting stats (e.g. player death)
func clear_modifiers() -> void:
	for modifier: StatModifierNode in _modifiers:
		modifier.depleted.disconnect(_modifier_depleted)
		modifier.queue_free()
	_modifiers.clear()
	_apply_modifiers()
