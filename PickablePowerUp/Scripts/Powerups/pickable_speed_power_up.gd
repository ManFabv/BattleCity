class_name PickableSpeedPowerUp
extends PickablePowerUpInterface

@export_group("Config")
## the stat modifier applied to the tank on pickup
@export var _speed_modifier : EntityStatsModifierInterface


## the speed modifier is applied to the tank for its duration
func _apply_pickup(controllable_entity_picker: ControllableEntity) -> void:
	# we apply the speed modifier to the tank
	controllable_entity_picker.apply_stat_modifier(_speed_modifier)
