class_name SpeedPowerUp
extends PickableInterface

## the stat modifier applied to the tank on pickup
@export var _speed_modifier : EntityStatsModifierInterface


func _apply_pickup(picker: ControllableEntity) -> void:
	picker.apply_stat_modifier(_speed_modifier)
