class_name PickableEntityStatsModifierPowerUp
extends PickablePowerUpInterface

@export_group("Config")
## the stat modifier applied to the entity on pickup
@export var _entity_stats_modifier : EntityStatsModifierInterface


## the stat modifier is applied to the entity for its duration
func _apply_pickup(controllable_entity_picker: ControllableEntity) -> void:
	# we apply the stat modifier to the entity
	controllable_entity_picker.apply_stat_modifier(_entity_stats_modifier)
