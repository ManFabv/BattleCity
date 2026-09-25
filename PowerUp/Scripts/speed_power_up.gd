class_name SpeedPowerUp
extends Pickable

## the stat modifier applied to the tank on pickup
@export var _speed_modifier : EntityStatsModifier


func _apply_pickup(picker: ControllableEntity) -> void:
	picker.apply_stat_modifier(_speed_modifier)
